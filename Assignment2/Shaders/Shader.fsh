varying lowp vec4 frag_Color;
varying lowp vec2 frag_TexCoord;
varying lowp vec3 frag_Normal;
varying lowp vec3 frag_Position;

uniform sampler2D u_Texture;
uniform highp float u_MatSpecularIntensity;
uniform highp float u_Shininess;
uniform lowp vec4 u_MatColor;
uniform lowp vec3 u_ViewPosition;

uniform bool flashlightEnabled;

uniform bool fogEnabled;
uniform bool u_FogMode;
uniform lowp vec3 u_FogColor;

uniform lowp float u_FogStart;
uniform lowp float u_FogEnd;

struct Light {
    lowp vec3 Color;
    lowp float AmbientIntensity;
    lowp float DiffuseIntensity;
    lowp vec3 Direction;
};
uniform Light u_Light;

struct Spotlight {
    lowp vec3 Position;
    lowp vec3 Direction;
    lowp float Cutoff;
    lowp float OuterCutoff;
};
uniform Spotlight u_Spotlight;

void main(void) {

    /*lowp vec3 ambient = u_Light.ambient * u_Material.ambient;
    
    lowp vec3 norm = normalize(frag_Normal);
    lowp vec3 lightDir = normalize(-u_Light.Direction);
    
    lowp float diff = max(dot(norm, lightDir), 0.0);
    lowp vec3 diffuse = u_Light.diffuse * (diff * u_Material.diffuse);
    
    lowp vec3 viewDir = normalize(u_ViewPosition - frag_Position);
    lowp vec3 reflectDir = reflect(-lightDir, norm);
    lowp float spec = pow(max(dot(viewDir, reflectDir), 0.0), u_Material.shininess);
    lowp vec3 specular = u_Light.specular * (spec * u_Material.specular);*/
    
    // Ambient
    lowp vec3 AmbientColor = u_Light.Color * u_Light.AmbientIntensity;
    
    // Diffuse
    lowp vec3 Normal = normalize(frag_Normal);
    lowp vec3 lightDir = normalize(-u_Light.Direction);
    lowp float DiffuseFactor = max(dot(Normal, lightDir), 0.0);
    lowp vec3 DiffuseColor = u_Light.Color * u_Light.DiffuseIntensity * DiffuseFactor;
    
    // Specular
    //lowp vec3 Eye = normalize(frag_Position);
    lowp vec3 viewDir = normalize(u_ViewPosition - frag_Position);
    lowp vec3 Reflection = reflect(lightDir, Normal);
    lowp float SpecularFactor = pow(max(dot(viewDir, Reflection), 0.0), u_Shininess);
    lowp vec3 SpecularColor = u_Light.Color * u_MatSpecularIntensity * SpecularFactor;
    
    //gl_FragColor = texture2D(u_Texture, frag_TexCoord) * vec4((AmbientColor + DiffuseColor + SpecularColor), 1.0);


    if(flashlightEnabled) {
        lowp vec3 flashlightDir = normalize(u_Spotlight.Position - frag_Position);
        lowp float theta = dot(flashlightDir, normalize(-u_Spotlight.Direction));
        lowp float intensity = max(0.0, (theta - u_Spotlight.Cutoff) / (1.0 - u_Spotlight.Cutoff));
        
        DiffuseColor  *= intensity;
        SpecularColor *= intensity;
        
       /* lowp float epsilon   = u_Spotlight.Cutoff - u_Spotlight.OuterCutoff;
        lowp float intensity = clamp((theta - u_Spotlight.OuterCutoff) / epsilon, 0.0, 1.0);
        
        DiffuseColor  *= intensity;
        SpecularColor *= intensity;*/
        
        if(theta > u_Spotlight.Cutoff)
        {
            gl_FragColor = texture2D(u_Texture, frag_TexCoord) * vec4((AmbientColor + DiffuseColor + SpecularColor), 1.0);
        } else { // else, use ambient light so scene isn't completely dark outside the spotlight.
            gl_FragColor = texture2D(u_Texture, frag_TexCoord) * vec4(AmbientColor, 1.0);
        }
    } else {
        if(fogEnabled) {
            if(u_FogMode) {
                lowp float d = length(u_ViewPosition - frag_Position);
                lowp float linearFog = clamp((u_FogEnd - d) / (u_FogEnd - u_FogStart), 0.0, 1.0);
                
                lowp vec3 color = AmbientColor + DiffuseColor + SpecularColor;
                lowp vec3 result = mix(color, u_FogColor, 1.0 - linearFog);

                gl_FragColor = texture2D(u_Texture, frag_TexCoord) * vec4(result, 1.0);
            }
        } else {
           gl_FragColor = texture2D(u_Texture, frag_TexCoord) * vec4((AmbientColor + DiffuseColor + SpecularColor), 1.0);
        }
    }

}

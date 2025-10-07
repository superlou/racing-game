shader_type spatial;
uniform sampler2D noise;
uniform float height_scale = 0.5;
uniform vec3 background_color = vec3(1., 0.8, 0.2);

void vertex() {
	VERTEX.y += 0.05 * cos(VERTEX.x) * cos(VERTEX.z);
	if (abs(VERTEX.x) > 0.95 || abs(VERTEX.z) > 0.95) {
		VERTEX.y = 0.0;
	}
}


float sdEquilateralTriangle( in vec2 p, in float r )
{
    const float k = sqrt(3.0);
    p.x = abs(p.x) - r;
    p.y = p.y + r/k;
    if( p.x+k*p.y>0.0 ) p = vec2(p.x-k*p.y,-k*p.x-p.y)/2.0;
    p.x -= clamp( p.x, -2.0*r, 0.0 );
    return -length(p)*sign(p.y);
}

void fragment() {
	float phase = mod(TIME, 1.);
	vec2 p = UV.xy - vec2(0.5, 0.0) - 1.0 * phase * vec2(0.0, 1.0);
	p *= 12.0;
	vec2 q = p - 4.0 * round (p / 4.0);
	ALBEDO = sdEquilateralTriangle(q, 1.0) < 0. ? vec3(1.0, 0.2 * sin(2.*PI*4.*phase), 0.0) : background_color;
}

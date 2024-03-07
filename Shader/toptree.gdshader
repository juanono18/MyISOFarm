shader_type canvas_item;

// Uniforms
uniform float time;
uniform float wind_strength : hint_range(0.0, 1.0);
uniform float frequency : hint_range(0.0, 10.0);
uniform float amplitude : hint_range(0.0, 50.0);

void vertex() {
    // Calculate displacement using a sine wave
    float displacement = sin(TIME * frequency + UV.x * 10.0 + UV.y * 10.0) * amplitude * wind_strength;

    // Apply displacement to the vertex position
    VERTEX.x += amplitude * sin((1.0-UV.y) * wind_strength * TIME);
}
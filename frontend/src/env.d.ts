import type { App } from 'vue';

declare global {
  interface LeafletLayer {
    bindPopup(content: string): LeafletLayer;
    addTo(target: unknown): LeafletLayer;
  }

  interface LeafletControl {
    collapse(): void;
  }

  interface Window {
    app: App<Element>;
    L: {
      layerGroup(): LeafletLayer;
      control: {
        layers(
          baseLayers: Record<string, LeafletLayer>,
          overlays: Record<string, LeafletLayer>,
          options: Record<string, unknown>
        ): { addTo(target: unknown): LeafletControl };
      };
      Polyline: new (
        points: unknown,
        options: Record<string, unknown>
      ) => LeafletLayer;
      polylineDecorator(
        line: unknown,
        options: Record<string, unknown>
      ): LeafletLayer;
      Symbol: {
        arrowHead(options: Record<string, unknown>): unknown;
      };
    };
    $clamp: (element: unknown, options: { clamp: number | string }) => void;
  }
}

export {};

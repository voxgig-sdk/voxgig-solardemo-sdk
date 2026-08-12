export interface Moon {
    diameter: number;
    id: string;
    kind: string;
    name: string;
    planet_id: string;
}
export interface MoonLoadMatch {
    id: string;
    planet_id: string;
}
export interface MoonListMatch {
    planet_id: string;
}
export interface MoonCreateData {
    planet_id: string;
    diameter: number;
    id: string;
    kind: string;
    name: string;
}
export interface MoonUpdateData {
    id: string;
    planet_id: string;
    diameter?: number;
    kind?: string;
    name?: string;
}
export interface MoonRemoveMatch {
    id: string;
    planet_id: string;
}
export interface Planet {
    diameter: number;
    forbid?: boolean;
    id: string;
    kind: string;
    name: string;
    ok?: boolean;
    start?: boolean;
    state?: string;
    stop?: boolean;
    why?: string;
}
export interface PlanetLoadMatch {
    id: string;
}
export interface PlanetListMatch {
    diameter?: number;
    forbid?: boolean;
    id?: string;
    kind?: string;
    name?: string;
    ok?: boolean;
    start?: boolean;
    state?: string;
    stop?: boolean;
    why?: string;
}
export interface PlanetCreateData {
    diameter: number;
    forbid?: boolean;
    id: string;
    kind: string;
    name: string;
    ok?: boolean;
    start?: boolean;
    state?: string;
    stop?: boolean;
    why?: string;
}
export interface PlanetUpdateData {
    id: string;
    diameter?: number;
    forbid?: boolean;
    kind?: string;
    name?: string;
    ok?: boolean;
    start?: boolean;
    state?: string;
    stop?: boolean;
    why?: string;
}
export interface PlanetRemoveMatch {
    id: string;
}

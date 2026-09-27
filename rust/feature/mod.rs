// VoxgigSolardemo SDK feature modules (mirrors tm/go/feature).
// Each feature is a Feature trait object registered on the client;
// `support` carries the shared option readers (go feature_options.go).

pub mod support;

pub mod base;
pub mod debug;
pub mod idempotency;
pub mod metrics;
pub mod paging;
pub mod ratelimit;
pub mod retry;
pub mod secrets;
pub mod test;
pub mod timeout;

// SolardemoError: the SDK error type (mirrors go core/error.go). The
// pipeline error discipline is Result<T, SolardemoError> throughout.

use crate::utility::voxgigstruct::Value;

#[derive(Clone, Debug)]
pub struct SolardemoError {
    pub sdk: String,
    pub code: String,
    pub msg: String,
    // Cleaned snapshots attached by makeError (Noval until then).
    pub result: Value,
    pub spec: Value,
    // HTTP status of the response that caused this error, or -1 when the
    // request never got one. PROMOTED to the top level: it used to be
    // reachable only inside `result`, so every consumer coupled itself to
    // the internal shape of that snapshot.
    pub status: i64,
}

impl SolardemoError {
    pub fn new(code: &str, msg: &str) -> SolardemoError {
        SolardemoError {
            sdk: "Solardemo".to_string(),
            code: code.to_string(),
            msg: msg.to_string(),
            result: Value::Noval,
            spec: Value::Noval,
            status: -1,
        }
    }

    pub fn not_found(&self) -> bool {
        404 == self.status
    }
}

impl std::fmt::Display for SolardemoError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(&self.msg)
    }
}

impl std::error::Error for SolardemoError {}

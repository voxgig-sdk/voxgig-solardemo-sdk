// prepare_auth utility.
//
// GENERATED, not templated - see PrepareAuth_rust.
//
// This SDK is configured with authentication off, so there is no credential
// to place. The function stays in the pipeline because make_spec calls it
// unconditionally.

use std::cell::RefCell;
use std::rc::Rc;

use crate::core::context::Context;
use crate::core::error::VoxgigSolardemoError;
use crate::core::spec::Spec;

pub fn prepare_auth_util(ctx: &Rc<Context>) -> Result<Rc<RefCell<Spec>>, VoxgigSolardemoError> {
    let spec = ctx.spec.borrow().clone().ok_or_else(|| {
        ctx.make_error("auth_no_spec", "Expected context spec property to be defined.")
    })?;

    Ok(spec)
}

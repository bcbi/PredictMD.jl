##### Beginning of file

# function next_major_version(
#         current_version::VersionNumber;
#         add_trailing_minus::Bool = false,
#         )::VersionNumber
#     if add_trailing_minus
#         trailing_minus = "-"
#     else
#         trailing_minus = ""
#     end
#     result = VersionNumber(
#         string(
#             current_version.major + 1,
#             ".",
#             0,
#             ".",
#             0,
#             trailing_minus,
#             )
#         )
#     return result
# end

# function next_minor_version(
#         current_version::VersionNumber;
#         add_trailing_minus::Bool = false,
#         )::VersionNumber
#     if add_trailing_minus
#         trailing_minus = "-"
#     else
#         trailing_minus = ""
#     end
#     result = VersionNumber(
#         string(
#             current_version.major,
#             ".",
#             current_version.minor + 1,
#             ".",
#             0,
#             trailing_minus,
#             )
#         )
#     return result
# end

# function next_patch_version(
#         current_version::VersionNumber;
#         add_trailing_minus::Bool = false,
#         )::VersionNumber
#     if add_trailing_minus
#         trailing_minus = "-"
#     else
#         trailing_minus = ""
#     end
#     result = VersionNumber(
#         string(
#             current_version.major,
#             ".",
#             current_version.minor,
#             ".",
#             current_version.patch + 1,
#             trailing_minus,
#             )
#         )
#     return result
# end

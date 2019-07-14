# import TikzPictures

# """
# """
# function save_plot(filename::AbstractString, tp::TikzPictures.TikzPicture)
#     filename = strip(filename)
#     if length(filename) == 0
#         error("filename is an empty string")
#     end
#     extension = filename_extension(filename)
#     if extension == ".pdf"
#         save_result = save_plot_pdf(filename, tp)
#     elseif extension == ".tex"
#         save_result = save_plot_tex(filename, tp)
#     elseif extension == ".tikz"
#         save_result = save_plot_tikz(filename, tp)
#     elseif extension == ".svg"
#         save_result = save_plot_svg(filename, tp)
#     else
#         error("File extension must be one of: .pdf, .tex, .tikz, .svg")
#     end
#     return filename
# end

# """
# """
# function save_plot_pdf(
#         filename::AbstractString,
#         tp::TikzPictures.TikzPicture,
#         )
#     filename = strip(filename)
#     if length(filename) == 0
#         error("filename is an empty string")
#     end
#     extension = filename_extension(filename)
#     if extension != ".pdf"
#         error("filename must end in .pdf")
#     end
#     parent_directory = Base.Filesystem.dirname(filename)
#     try
#         Base.Filesystem.mkpath(parent_directory)
#     catch
#     end
#     save_result = try
#         TikzPictures.save(TikzPictures.PDF(filename), tp)
#     catch e
#         handle_plotting_error(e)
#     end
#     return filename
# end

# """
# """
# function save_plot_tex(
#         filename::AbstractString,
#         tp::TikzPictures.TikzPicture,
#         )
#     filename = strip(filename)
#     if length(filename) == 0
#         error("filename is an empty string")
#     end
#     extension = filename_extension(filename)
#     if extension != ".tex"
#         error("filename must end in .tex")
#     end
#     parent_directory = Base.Filesystem.dirname(filename)
#     try
#         Base.Filesystem.mkpath(parent_directory)
#     catch
#     end
#     save_result = try
#         TikzPictures.save(TikzPictures.TEX(filename), tp)
#     catch e
#         handle_plotting_error(e)
#     end
#     return filename
# end

# """
# """
# function save_plot_tikz(
#         filename::AbstractString,
#         tp::TikzPictures.TikzPicture,
#         )
#     filename = strip(filename)
#     if length(filename) == 0
#         error("filename is an empty string")
#     end
#     if extension != ".tikz"
#         error("filename must end in .tikz")
#     end
#     extension = filename_extension(filename)
#     parent_directory = Base.Filesystem.dirname(filename)
#     try
#         Base.Filesystem.mkpath(parent_directory)
#     catch
#     end
#     save_result = try
#         TikzPictures.save(TikzPictures.TIKZ(filename), tp)
#     catch e
#         handle_plotting_error(e)
#     end
#     return filename
# end

# """
# """
# function save_plot_svg(
#         filename::AbstractString,
#         tp::TikzPictures.TikzPicture,
#         )
#     filename = strip(filename)
#     if length(filename) == 0
#         error("filename is an empty string")
#     end
#     extension = filename_extension(filename)
#     if extension != ".svg"
#         error("filename must end in .svg")
#     end
#     parent_directory = Base.Filesystem.dirname(filename)
#     try
#         Base.Filesystem.mkpath(parent_directory)
#     catch
#     end
#     save_result = try
#         TikzPictures.save(TikzPictures.SVG(filename), tp)
#     catch e
#         handle_plotting_error(e)
#     end
#     return filename
# end

# """
# """
# function open_plot(tp::TikzPictures.TikzPicture)
#     temp_svg_filename = string(tempname(), ".svg")
#     save_result = open_plot(temp_svg_filename, tp)
#     return temp_svg_filename
# end

# """
# """
# function open_plot(
#         filename::AbstractString,
#         tp::TikzPictures.TikzPicture,
#         )
#     filename = strip(filename)
#     if length(filename) == 0
#         error("filename is an empty string")
#     end
#     saveresult = save_plot(filename, tp)
#     open_result = open_browser_window(filename)
#     return filename
# end


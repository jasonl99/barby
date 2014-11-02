require 'barby/outputter'

module Barby

  #Annotates a PDFWriter document with the barcode
  #
  #Registers the annotate_pdf method
  class PDFWriterOutputter < Outputter

    register :annotate_pdf

    attr_accessor :x, :y, :height, :xdim


    #Annotate a PDFWriter document with the barcode
    #
    #Valid options are:
    #
    #x, y   - The point in the document to start rendering from
    #height - The height of the bars in PDF units
    #xdim   - The X dimension in PDF units
    def annotate_pdf(pdf, options={})
      with_options options do

        xpos, ypos = x, y
        orig_xpos = xpos

        if barcode.two_dimensional?
          boolean_groups.reverse_each do |groups|
            groups.each do |bar,amount|
              if bar
                pdf.move_to(xpos, ypos)
                  pdf.line_to(xpos, ypos+xdim)
                  pdf.line_to(xpos+(xdim*amount), ypos+xdim)
                  pdf.line_to(xpos+(xdim*amount), ypos)
                  pdf.line_to(xpos, ypos)
                  pdf.fill
              end
              xpos += (xdim*amount)
            end
            xpos = orig_xpos
            ypos += xdim
          end
        else
          boolean_groups.each do |bar,amount|
            if bar
              pdf.move_to(xpos, ypos)
                pdf.line_to(xpos, ypos+height)
                pdf.line_to(xpos+(xdim*amount), ypos+height)
                pdf.line_to(xpos+(xdim*amount), ypos)
                pdf.line_to(xpos, ypos)
                pdf.fill
            end
            xpos += (xdim*amount)
          end
        end

      end

      pdf
    end


    def x
      @x || 10
    end

    def y
      @y || 10
    end

    def height
      @height || 50
    end

    def xdim
      @xdim || 1
    end


  end

end

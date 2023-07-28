$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.CLASS.SELECTION
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SHANKAR RAJU
* Program Name  : REDO.CONV.CLASS.SELECTION
*-------------------------------------------------------------------------
* Description: This routine is a conversion routine to format Classification
*----------------------------------------------------------
* Linked with: All enquiries with Customer no as selection field
* In parameter : N/A
* out parameter : N/A
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE        WHO             ODR                 DESCRIPTION
* 01-AUG-11   SHANKAR RAJU    PACS00094166      Routine to format
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion  - No changes
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    GOSUB PROCESS

RETURN

*------------
PROCESS:
*-------------
    Y.CLASS = O.DATA

    SEL.1 = ''
    SEL.2 = ''
    SEL.3 = ''
    SEL.4 = ''
    SEL.5 = ''
    SEL.6 = ''
    SEL.7 = ''

    Y.SEL.1 = FIELD(Y.CLASS,",",1)
    Y.SEL.11 = FIELD(Y.SEL.1,"-",1)
    Y.SEL.12 = FIELD(Y.SEL.1,"-",2)
    IF Y.SEL.12 THEN
        SEL.1 = Y.SEL.11:"-":Y.SEL.12
        Y.FINAL.ARR = SEL.1
    END

    Y.SEL.2 = FIELD(Y.CLASS,",",2)
    Y.SEL.21 = FIELD(Y.SEL.2,"-",1)
    Y.SEL.22 = FIELD(Y.SEL.2,"-",2)
    IF Y.SEL.22 THEN
        IF Y.FINAL.ARR NE '' THEN
            Y.FINAL.ARR := ",":Y.SEL.21:"-":Y.SEL.22
        END ELSE
            Y.FINAL.ARR = Y.SEL.21:"-":Y.SEL.22
        END
    END

    Y.SEL.3 = FIELD(Y.CLASS,",",3)
    Y.SEL.31 = FIELD(Y.SEL.3,"-",1)
    Y.SEL.32 = FIELD(Y.SEL.3,"-",2)
    IF Y.SEL.32 THEN
        IF Y.FINAL.ARR NE '' THEN
            Y.FINAL.ARR := ",":Y.SEL.31:"-":Y.SEL.32
        END ELSE
            Y.FINAL.ARR = Y.SEL.31:"-":Y.SEL.32
        END
    END

    Y.SEL.4 = FIELD(Y.CLASS,",",4)
    Y.SEL.41 = FIELD(Y.SEL.4,"-",1,2)
    Y.SEL.42 = FIELD(Y.SEL.4,"-",3)
    Y.SEL.421 = FIELD(Y.SEL.42," ",2)
    Y.SEL.421 = ICONV(Y.SEL.421,"D2")
    Y.SEL.421 = OCONV(Y.SEL.421,"D4")
    Y.SEL.422 = FIELD(Y.SEL.42," ",3)
    Y.SEL.422 = ICONV(Y.SEL.422,"D2")
    Y.SEL.422 = OCONV(Y.SEL.422,"D4")
    SEL.4 = Y.SEL.41:"-":Y.SEL.421

    IF Y.SEL.422 THEN
        SEL.4 = SEL.4:" ":Y.SEL.422
    END

    IF Y.FINAL.ARR NE '' THEN
        Y.FINAL.ARR := ",":SEL.4
    END ELSE
        Y.FINAL.ARR = SEL.4
    END

    Y.SEL.5 = FIELD(Y.CLASS,",",5)
    Y.SEL.51 = FIELD(Y.SEL.5,"-",1,2)
    Y.SEL.52 = FIELD(Y.SEL.5,"-",3)
    Y.SEL.521 = FIELD(Y.SEL.52," ",2)
    Y.SEL.521 = ICONV(Y.SEL.521,"D2")
    Y.SEL.521 = OCONV(Y.SEL.521,"D4")
    Y.SEL.522 = FIELD(Y.SEL.52," ",3)
    Y.SEL.522 = ICONV(Y.SEL.522,"D2")
    Y.SEL.522 = OCONV(Y.SEL.522,"D4")
    SEL.5 = Y.SEL.51:"-":Y.SEL.521

    IF Y.SEL.522 THEN
        SEL.5 = SEL.5:" ":Y.SEL.522
    END

    Y.FINAL.ARR := ",":SEL.5

    Y.SEL.6 = FIELD(Y.CLASS,",",6)
    Y.SEL.61 = FIELD(Y.SEL.6,"-",1)
    Y.SEL.62 = FIELD(Y.SEL.6,"-",2)
    IF Y.SEL.62 THEN
        Y.FINAL.ARR := ",":Y.SEL.61:"-":Y.SEL.62
    END

    Y.SEL.7 = FIELD(Y.CLASS,",",7)
    Y.SEL.71 = FIELD(Y.SEL.7,"-",1)
    Y.SEL.72 = FIELD(Y.SEL.7,"-",2)
    IF Y.SEL.72 THEN
        Y.FINAL.ARR := ",":Y.SEL.71:"-":Y.SEL.72
    END

    O.DATA      = Y.FINAL.ARR

RETURN
END

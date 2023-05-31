* @ValidationCode : Mjo3MjQxMzk1NjY6Q3AxMjUyOjE2ODIwNzMzNzk4ODM6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.SEL.BAD.REF.ENQ
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CONV.SEL.BAD.REF.ENQ
*--------------------------------------------------------------------------------------------------------
*Description  : This is a Conversion routine REDO.ENQ.CUS.BAD.REF
*Linked With  : REDO.CONV.SEL.BAD.REF.ENQ
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                      Reference               Description
*   ------         ------                    -------------            -------------
*  8-1-2014       DEEPAK KUMAR K               B.42
*
* 13-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    Y.SEL.INPUTTED.FLDS = ENQ.SELECTION<2>

    IF Y.SEL.INPUTTED.FLDS THEN
        LOCATE 'NUMERO.DOCUMENTO' IN Y.SEL.INPUTTED.FLDS<1,1> SETTING Y.DOC.NO.POS THEN
            Y.SEL.DISP := 'Numero Documento : ':ENQ.SELECTION<4, Y.DOC.NO.POS>:'; '
        END
        LOCATE 'TIPO.DE.DOCUMENTO' IN Y.SEL.INPUTTED.FLDS<1,1> SETTING Y.TIPO.DOC.POS THEN
            Y.SEL.DISP := 'Tipo de Documento : ':ENQ.SELECTION<4, Y.TIPO.DOC.POS>:'; '
        END
        LOCATE 'LISTA.RESTRICTIVA' IN Y.SEL.INPUTTED.FLDS<1,1> SETTING Y.RESTR.LIST.POS THEN
            Y.SEL.DISP := 'Tipo de Lista Restrictiva : ':ENQ.SELECTION<4, Y.RESTR.LIST.POS>:'; '
        END
        LOCATE 'TIPO.DE.PERSONA' IN Y.SEL.INPUTTED.FLDS<1,1> SETTING Y.TIPO.PERS.POS THEN
            Y.SEL.DISP := ' Tipo de Cliente : ':ENQ.SELECTION<4, Y.TIPO.PERS.POS>:'; '
        END
        LOCATE 'DATE.TIME' IN Y.SEL.INPUTTED.FLDS<1,1> SETTING Y.DATE.TIME.POS THEN
            Y.SEL.DATE = ENQ.SELECTION<4, Y.DATE.TIME.POS>
            Y.START.DATE = FIELD(Y.SEL.DATE, ' ', 1)
            Y.END.DATE = FIELD(Y.SEL.DATE, ' ', 2)
            Y.START.DATE = '20':Y.START.DATE[1,6]
            Y.END.DATE = '20':Y.END.DATE[1,6]
            CALL EB.DATE.FORMAT.DISPLAY(Y.START.DATE, Y.START.DATE1, '', '')
            CALL EB.DATE.FORMAT.DISPLAY(Y.END.DATE, Y.END.DATE1, '', '')
            Y.SEL.DISP := 'Fecha de Ingreso Cliente : ':Y.START.DATE1:' A ':Y.END.DATE1:'; '
        END
        O.DATA = Y.SEL.DISP
    END ELSE
        O.DATA = 'TODOS'
    END

RETURN
END

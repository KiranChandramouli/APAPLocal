$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.V.CUSSEGMENT.RT
    $INSERT I_EQUATE  ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_COMMON
    $INSERT I_F.IC.LAPAP.CLO.CHARGE.PARAM  ;*R22 AUTO CODE CONVERSION.END
*----------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*13-07-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*13-07-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------------------
*Company   Name    : Asociacion Popular de Ahorros y Prestamos
*Developed By      : J.Q.
*Program   Name    : LAPAP.V.CUSSEGMENT.RT
*Reference         : CTO-9
*Date              : 2022-06-03
*----------------------------------------------------------------------------------------------

*DESCRIPTION       : THIS PROGRAM IS USED TO VALIDATE CUSTOMER SEGMENT IN VERSIONS OF
*                    IC.LAPAP.CLO.CHARGE.PARAM
* ---------------------------------------------------------------------------------------------
    Y.CURR.CUS.SEGMENT = COMI
    Y.CUS.SEGMENT = R.NEW(IC.LAP86.CUS.SEGMENT)

    IF Y.CUS.SEGMENT THEN
        IF MESSAGE EQ 'VAL' THEN
            AF = IC.LAP86.CUS.SEGMENT
            CALL DUP
        END ELSE
            LOCATE Y.CURR.CUS.SEGMENT IN Y.CUS.SEGMENT<1,1> SETTING POS.SEG THEN
                ETEXT = 'IC-DUP.CUSSEG.PROP'
                AF = IC.LAP86.CUS.SEGMENT
                CALL STORE.END.ERROR
            END
        END
    END

END

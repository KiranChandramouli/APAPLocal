SUBROUTINE LAPAP.V.CUSSEGMENT.RT
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.IC.LAPAP.CLO.CHARGE.PARAM
*----------------------------------------------------------------------------------------------
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

SUBROUTINE REDO.V.VAL.CLAIM.TYPE
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.CLAIM.TYPE
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is the validation routine to validate the cliam type
*
*
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 16-APR-2010        Prabhu.N       ODR-2010-08-0031   Initial Creation
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.SLA.PARAM
    $INSERT I_F.REDO.ISSUE.CLAIMS
    $INSERT I_F.REDO.ISSUE.REQUESTS
    $INSERT I_System
    GOSUB INIT
RETURN
*---
INIT:
*---
    FN.REDO.SLA.PARAM='F.REDO.SLA.PARAM'
    F.REDO.SLA.PARAM=''
    CALL OPF(FN.REDO.SLA.PARAM,F.REDO.SLA.PARAM)

    IF APPLICATION EQ 'REDO.ISSUE.CLAIMS' AND PGM.VERSION EQ ',ARC.NEW' OR PGM.VERSION EQ ',ARC.NEW.CONFIRM' THEN
        REDO.SLA.PARAM.ID = R.NEW(ISS.CL.SLA.ID)
    END

    IF APPLICATION EQ 'REDO.ISSUE.REQUESTS' AND PGM.VERSION EQ ',ARC.NEW' OR PGM.VERSION EQ ',ARC.NEW.CONFIRM' THEN
        REDO.SLA.PARAM.ID = R.NEW(ISS.REQ.SLA.ID)
    END

    CALL F.READ(FN.REDO.SLA.PARAM,REDO.SLA.PARAM.ID,R.REDO.SLA.PARAM,F.REDO.SLA.PARAM,REDO.SLA.PARAM.ER)

    Y.DESC = R.REDO.SLA.PARAM<SLA.DESCRIPTION>
    CHANGE @VM TO @FM IN Y.DESC

    LOCATE COMI IN Y.DESC<1> SETTING Y.DESC.POS ELSE
        ETEXT = 'EB-INVALID.CLAIM'
        CALL STORE.END.ERROR
    END

RETURN
END
*---------------------------------------------*END OF SUBROUTINE*-------------------------------------------

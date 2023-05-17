* Version 2 02/06/00  GLOBUS Release No. G11.0.00 29/06/00
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE REDO.MONITOR.PARAMETER.VALIDATE
*-----------------------------------------------------------------------------
*** Template FOR validation routines
* @author youremail@temenos.com
* @stereotype validator
* @package infra.eb
*!
*-----------------------------------------------------------------------------
*** <region name= Modification History>
*-----------------------------------------------------------------------------
* 19/09/2010 - Cesar Yepez
*              Creation
*-----------------------------------------------------------------------------
*** </region>
*** <region name= Main section>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.MONITOR.PARAMETER

    GOSUB INITIALISE
    GOSUB PROCESS.MESSAGE
RETURN
*** </region>
*-----------------------------------------------------------------------------
VALIDATE:
* TODO - Add the validation code here.
* Set AF, AV and AS to the field, multi value and sub value and invoke STORE.END.ERROR
* Set ETEXT to point to the EB.ERROR.TABLE

*      AF = MY.FIELD.NAME                 <== Name of the field
*      ETEXT = 'EB-EXAMPLE.ERROR.CODE'    <== The error code
*      CALL STORE.END.ERROR               <== Needs to be invoked per error


*Version Validation
    Y.NUM.VM = DCOUNT(R.NEW(REDO.MON.PARAM.VERSION.NAME),@VM)
    FOR Y.COUNT.VM=1 TO Y.NUM.VM
        Y.NUM.SM = DCOUNT(R.NEW(REDO.MON.PARAM.VER.MAP.REF)<1,Y.COUNT.VM>,@SM)
        IF Y.NUM.SM EQ '0' THEN
            AF = REDO.MON.PARAM.VER.MAP.REF ; AV = Y.COUNT.VM ; AS = 1
            ETEXT = 'EB-FIELD.MISSING'
            CALL STORE.END.ERROR
        END
    NEXT Y.COUNT.VM

*Enquiry Validation
    Y.ENQ.GEN.MAP = R.NEW(REDO.MON.PARAM.GEN.MAP.ENQ)
    Y.ENQ.VM = DCOUNT(R.NEW(REDO.MON.PARAM.ENQUIRY.NAME),@VM)
    FOR Y.COUNT.VM=1 TO Y.ENQ.VM
        Y.ENQ.MAP = R.NEW(REDO.MON.PARAM.ENQ.MAP.REF)<1,Y.COUNT.VM>
        IF Y.ENQ.MAP EQ '' AND Y.ENQ.GEN.MAP EQ '' THEN
            AF = REDO.MON.PARAM.ENQ.MAP.REF ; AV = Y.COUNT.VM ; AS = 1
            ETEXT = 'EB-FIELD.MISSING'
            CALL STORE.END.ERROR
        END
    NEXT Y.COUNT.VM

*Fields Validation
    Y.FIELD.MAP = R.NEW(REDO.MON.PARAM.FIELD.MAP.REF)
    Y.FIELD.VM = DCOUNT(R.NEW(REDO.MON.PARAM.FIELD.NAME),@VM)
    IF Y.FIELD.VM GT 0 AND Y.FIELD.MAP EQ '' THEN
        AF = REDO.MON.PARAM.FIELD.MAP.REF ; AV = 1 ; AS = 1
        ETEXT = 'EB-FIELD.MISSING'
        CALL STORE.END.ERROR
    END


RETURN
*-----------------------------------------------------------------------------
*** <region name= Initialise>
INITIALISE:
***

*
RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= Process Message>
PROCESS.MESSAGE:
    BEGIN CASE
        CASE MESSAGE EQ ''          ;* Only during commit...
            BEGIN CASE
                CASE V$FUNCTION EQ 'D'
                    GOSUB VALIDATE.DELETE
                CASE V$FUNCTION EQ 'R'
                    GOSUB VALIDATE.REVERSE
                CASE OTHERWISE  ;* The real VALIDATE...
                    GOSUB VALIDATE
            END CASE
        CASE MESSAGE EQ 'AUT' OR MESSAGE EQ 'VER'       ;* During authorisation and verification...
            GOSUB VALIDATE.AUTHORISATION
    END CASE
*
RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= VALIDATE.DELETE>
VALIDATE.DELETE:
* Any special checks for deletion

RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= VALIDATE.REVERSE>
VALIDATE.REVERSE:
* Any special checks for reversal

RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= VALIDATE.AUTHORISATION>
VALIDATE.AUTHORISATION:
* Any special checks for authorisation

RETURN
*** </region>
*-----------------------------------------------------------------------------
END

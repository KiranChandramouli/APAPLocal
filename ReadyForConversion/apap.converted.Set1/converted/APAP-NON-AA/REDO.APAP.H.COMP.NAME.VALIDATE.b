* Version 2 02/06/00  GLOBUS Release No. G11.0.00 29/06/00
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE REDO.APAP.H.COMP.NAME.VALIDATE
*-----------------------------------------------------------------------------
*** Template FOR validation routines
* @author youremail@temenos.com
* @stereotype validator
* @package infra.eb
*!
*-----------------------------------------------------------------------------
*** <region name= Modification History>
*-----------------------------------------------------------------------------
* 07/06/06 - BG_100011433
*            Creation
*-----------------------------------------------------------------------------
*** </region>
*** <region name= Main section>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.H.COMP.NAME

    GOSUB INITIALISE
    GOSUB PROCESS.MESSAGE
RETURN
*** </region>
*-----------------------------------------------------------------------------
VALIDATE:
* TODO - Add the validation code here
* Set AF, AV and AS to the field, multi value and sub value and invoke STORE.END.ERROR
* Set ETEXT to point to the EB.ERROR.TABLE

*      AF = MY.FIELD.NAME                 <== Name of the field
*      ETEXT = 'EB-EXAMPLE.ERROR.CODE'    <== The error code
*      CALL STORE.END.ERROR               <== Needs to be invoked per error

    IF R.NEW(REDO.CMP.CLASS.POLICY) EQ 'GROUP' AND R.NEW(REDO.CMP.SEN.POLICY.NUM) EQ '' THEN
        AF = REDO.CMP.SEN.POLICY.NUM
        ETEXT = 'EB-REDO.CMP.SEN.POLICY.NUM'
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
        CASE MESSAGE EQ ''          ;* Only during commit
            BEGIN CASE
                CASE V$FUNCTION EQ 'D'
                    GOSUB VALIDATE.DELETE
                CASE V$FUNCTION EQ 'R'
                    GOSUB VALIDATE.REVERSE
                CASE OTHERWISE  ;* The real VALIDATE
                    GOSUB VALIDATE
            END CASE
        CASE MESSAGE EQ 'AUT' OR MESSAGE EQ 'VER'       ;* During authorisation and verification
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

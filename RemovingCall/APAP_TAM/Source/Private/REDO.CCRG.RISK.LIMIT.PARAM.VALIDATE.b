* @ValidationCode : MjotMTQ4OTI3NDA1MzpDcDEyNTI6MTY4NDg0MTg5NTA5ODpJVFNTOi0xOi0xOi0xMTA6MTpmYWxzZTpOL0E6UjIyX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:08:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -110
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CCRG.RISK.LIMIT.PARAM.VALIDATE
*-----------------------------------------------------------------------------
*!** Template FOR validation routines
* @author:    anoriega@temenos.com
* @stereotype validator:
* @package:   REDO.CCRG
*!
*-----------------------------------------------------------------------------
*** <region name= Modification History>
*-----------------------------------------------------------------------------
* 31/March/2011 - BG_100011433
*                 Creation Routine
* 13/April/2011 - vpanchi
*                 Modify for various applications
** 05-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM, I to I.VAR, J to J.VAR
** 05-04-2023 Skanda R22 Manual Conversion one change line no. 155
*-----------------------------------------------------------------------------
*** </region>
*** <region name= Main section>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CCRG.RISK.LIMIT.PARAM
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
*
*
    Y.CNT.APP  = DCOUNT(R.NEW(REDO.CCRG.RLP.APPLICATION),@VM)
    Y.CNT.FLDS = DCOUNT(R.NEW(REDO.CCRG.RLP.FIELD.NO),@SM)

* If the ID is RISK.INDIV.SECURED or RISK.INDIV.UNSECURED or RISK.GROUP.TOTAL or RISK.INDIV.TOTAL,
* is not required to input the conditions fields
* IF  Y.RL.ID MATCHES 'RISK.INDIV.SECURED':VM:'RISK.INDIV.UNSECURED':VM:'RISK.GROUP.TOTAL':VM:'RISK.INDIV.TOTAL' THEN

* << PP moved to RECORD routine
*  IF  Y.RL.ID MATCHES 'RISK.GROUP.TOTAL' THEN
*      IF Y.CNT.FLDS GT 0 AND R.NEW(REDO.CCRG.RLP.FIELD.NO)<1,1,1> NE '' THEN
*         AF    = REDO.CCRG.RLP.APPLICATION
*         ETEXT = 'ST-REDO.CCRG.CONDTS.NOT.APPLY.TO.RL':FM:Y.RL.ID
*         CALL STORE.END.ERROR
*         RETURN
*      END
*      RETURN
*   END
* >>
*
    I.VAR  = ''
    FOR I.VAR = 1 TO Y.CNT.APP
* Set fields to indicate the messages
        AV = I.VAR
* Validate APPLICATION
        Y.APPLICATION = R.NEW(REDO.CCRG.RLP.APPLICATION)<1,I.VAR>
*CALL APAP.TAM.REDO.CCRG.ALLOWED.APP('VALIDATE', Y.APPLICATION)
        CALL APAP.TAM.redoCcrgAllowedApp('VALIDATE', Y.APPLICATION) ;*R22 Manual Conversion
        IF END.ERROR THEN
            RETURN
        END

* ------- Validate that an application is not duplicated ------------*
        IF I.VAR GT 1 AND Y.APPLICATION MATCHES Y.APPS THEN
            ETEXT = 'ST-REDO.CCRG.APPLICATION.DUPLICATED':@FM:Y.APPLICATION
            CALL STORE.END.ERROR
            RETURN
        END
        Y.APPS = Y.APPS:@VM:Y.APPLICATION
* ----------------------------------------------------------------------*

        J.VAR = ''
        Y.CNT.FLDS = ''
        Y.CNT.FLDS = DCOUNT(R.NEW(REDO.CCRG.RLP.FIELD.NO)<1,I.VAR>,@SM)
        IF NOT(Y.CNT.FLDS) THEN
            AF    = REDO.CCRG.RLP.FIELD.NO
            AV    = I.VAR
            AS    = 1
            ETEXT = 'ST-REDO.CCRG.FIELD.NO.INPUT'
            CALL STORE.END.ERROR
            RETURN
        END

        GOSUB VALIDATE.FIELDS

    NEXT I.VAR  ;*Application
*
RETURN
*-----------------------------------------------------------------------------
*** <region name= VALIDATE.FIELDS>
VALIDATE.FIELDS:
***
    Y.FIELDS = ''
    FOR J.VAR = 1 TO Y.CNT.FLDS
* Set fields to indicate the messages
        AS = J.VAR
* Validate de Fields in Application entered
        Y.FIELD.NO = R.NEW(REDO.CCRG.RLP.FIELD.NO)<1,I.VAR,J.VAR>
        Y.FIELD.POS = ''
        R.STANDARD.SELECTION = ''
* CALL APAP.TAM.REDO.R.MULTI.GET.FIELD.NO(Y.APPLICATION,Y.FIELD.NO, R.STANDARD.SELECTION, Y.FIELD.POS)
        CALL APAP.TAM.redoRMultiGetFieldNo(Y.APPLICATION,Y.FIELD.NO, R.STANDARD.SELECTION, Y.FIELD.POS) ;*R22 Manual Conversion
        IF NOT(Y.FIELD.POS) THEN
            AF    = REDO.CCRG.RLP.FIELD.NO
            AV    = I.VAR
            AS    = J.VAR
            ETEXT = 'ST-REDO.CCRG.FIELD.NOT.APPLY.FOR.APP': @FM :Y.FIELD.NO: @VM :Y.APPLICATION
            CALL STORE.END.ERROR
            RETURN
        END

* ------- Validate that an field is not duplicated ------------*
        IF J.VAR GT 1 AND Y.FIELD.NO MATCHES Y.FIELDS THEN
            AF    = REDO.CCRG.RLP.FIELD.NO
            AV    = I.VAR
            ETEXT = 'ST-REDO.CCRG.FIELD.DUPLICATED':@FM:Y.FIELD.NO
            CALL STORE.END.ERROR
            RETURN
        END
        Y.FIELDS = Y.FIELDS:@VM:Y.FIELD.NO
*---------------------------------------------------------------*

* If there is data in the FIELD.NO has to be information in these fields: OPERATOR and MIN.VALUE or MAX.VALUE
        R.CONDITIONS = ''

* Modified for extract the correct values by each application
        R.CONDITIONS<REDO.CCRG.RLP.OPERATOR>  = R.NEW(REDO.CCRG.RLP.OPERATOR)<1,I.VAR,J.VAR>
        R.CONDITIONS<REDO.CCRG.RLP.MIN.VALUE> = R.NEW(REDO.CCRG.RLP.MIN.VALUE)<1,I.VAR,J.VAR>
        R.CONDITIONS<REDO.CCRG.RLP.MAX.VALUE> = R.NEW(REDO.CCRG.RLP.MAX.VALUE)<1,I.VAR,J.VAR>
        R.CONDITIONS<REDO.CCRG.RLP.BOOL.OPER> = R.NEW(REDO.CCRG.RLP.BOOL.OPER)<1,I.VAR,J.VAR>

        R.VALUES    = ''
        R.VALUES<1> = I.VAR
        R.VALUES<2> = Y.CNT.APP
        R.VALUES<3> = J.VAR
        R.VALUES<4> = Y.CNT.FLDS
* All fields
* CALL APAP.TAM.REDO.CCRG.VALIDATE.CONDITIONS(R.CONDITIONS, R.VALUES) ;* R22 Manual Conversion
        CALL APAP.TAM.redoCcrgValidateConditions(R.CONDITIONS, R.VALUES) ;*R22 Manual Conversion
        IF END.ERROR THEN
            RETURN
        END
    NEXT J.VAR  ;*Fields
RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= Initialise>
INITIALISE:
***
    R.CONDITIONS  = ''
    Y.RL.ID       = ID.NEW
    Y.APPS        = ''
    Y.FIELDS      = ''
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

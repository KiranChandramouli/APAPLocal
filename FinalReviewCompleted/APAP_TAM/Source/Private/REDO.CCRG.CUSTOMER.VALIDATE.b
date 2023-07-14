* @ValidationCode : Mjo5MTkzODQ5MTpDcDEyNTI6MTY4MDY3OTkzNTY0NjpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 13:02:15
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
$PACKAGE APAP.TAM
* Version 2 02/06/00  GLOBUS Release No. G11.0.00 29/06/00
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE REDO.CCRG.CUSTOMER.VALIDATE
*-----------------------------------------------------------------------------
* Template FOR validation routines APPLICATION REDO.CCRG.CUSTOMER
* @author hpasquel@temenos.com
* @stereotype validator
* @package redo.ccrg
*!
*-----------------------------------------------------------------------------
*** <region name= Modification History>
*-----------------------------------------------------------------------------
* 05/04/11 - APAP - B5
*            First Version

* Date             Who                   Reference      Description
* 05.04.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM, FM TO @FM
* 05.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*-----------------------------------------------------------------------------
*** </region>
*** <region name= Main section>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.CUSTOMER
*
    $INSERT I_F.REDO.CCRG.CUSTOMER
*
    GOSUB INITIALISE
    GOSUB PROCESS.MESSAGE
*
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

    GOSUB VALIDATE.CUSTOMER

    IF ETEXT THEN
        CALL STORE.END.ERROR
    END

RETURN
*-----------------------------------------------------------------------------
*** <region name= Initialise>
INITIALISE:
***

    F.CUSTOMER = ''
    FN.CUSTOMER = 'F.CUSTOMER'
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)
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
*** <region name= VALIDATE.CUSTOMER>
VALIDATE.CUSTOMER:
* Validate if one of the identification were input

    IF OFS$NEWRECORD EQ 1 THEN
        RETURN
    END

    Y.EMPTY.ID = ''
    Y.EMPTY.ID := R.NEW(REDO.CCRG.CUS.CU.CIDENT)
    Y.EMPTY.ID := R.NEW(REDO.CCRG.CUS.CU.LEGAL.ID)
    Y.EMPTY.ID := R.NEW(REDO.CCRG.CUS.CU.RNC)
    IF  Y.EMPTY.ID EQ ''  AND R.NEW(REDO.CCRG.CUS.CUSTOMER.ID) EQ '' THEN
        AF = REDO.CCRG.CUS.CUSTOMER.ID
        ETEXT = 'ST-REDO.CCRG.INDENTIF.MISSING'
        RETURN
    END

    Y.SEL.CMD = "SELECT " : FN.CUSTOMER : " "

    Y.TYPE = ''
    Y.IDEN = ''

    BEGIN CASE
        CASE R.NEW(REDO.CCRG.CUS.CU.CIDENT) NE ''
            GOSUB PROCESS.CIDENT
        CASE R.NEW(REDO.CCRG.CUS.CU.RNC) NE ''
            GOSUB PROCESS.RNC
        CASE R.NEW(REDO.CCRG.CUS.CU.LEGAL.ID) NE ''
            GOSUB PROCESS.PASS
        CASE R.NEW(REDO.CCRG.CUS.CUSTOMER.ID) NE ''
            RETURN
    END CASE

    CUSTOMER.ERR = ""

    CALL EB.READLIST(Y.SEL.CMD, CUSTOMER.LIST, "", CUSTOMER.NO.OF.REC, CUSTOMER.ERR)

    IF CUSTOMER.LIST EQ "" AND CUSTOMER.NO.OF.REC LE 0 THEN
        R.NEW(REDO.CCRG.CUS.CUSTOMER.ID) = ""
        OFS$ENRI<REDO.CCRG.CUS.CUSTOMER.ID,1> = ""
        ETEXT = "ST-REDO.CCRG.CUSTOMER.IDENTIFICATION.NOT.FOUND" : @FM : Y.TYPE : @VM : Y.IDEN
        RETURN
    END

    R.NEW(REDO.CCRG.CUS.CUSTOMER.ID) = CUSTOMER.LIST<1>
*
    RESULT = ''
    CALL ENQ.TRANS(RESULT,'CUSTOMER',CUSTOMER.LIST<1>,EB.CUS.SHORT.NAME)

    IF RESULT<1,LNGG> NE '' THEN
        OFS$ENRI<REDO.CCRG.CUS.CUSTOMER.ID,1> = RESULT<1,LNGG>
    END ELSE
        OFS$ENRI<REDO.CCRG.CUS.CUSTOMER.ID,1> = RESULT<1,1>
    END
*
RETURN
*** </region>
*---------------------------------------------------------------------------------------------------------------------------------------------------
PROCESS.CIDENT:
*---------------------------------------------------------------------------------------------------------------------------------------------------
*
    Y.TYPE = "CIDENT"
    Y.IDEN = R.NEW(REDO.CCRG.CUS.CU.CIDENT)
    Y.SEL.CMD := " WITH L.CU.CIDENT EQ " : R.NEW(REDO.CCRG.CUS.CU.CIDENT)
    AF = REDO.CCRG.CUS.CU.CIDENT
RETURN
*---------------------------------------------------------------------------------------------------------------------------------------------------
PROCESS.RNC:
*---------------------------------------------------------------------------------------------------------------------------------------------------

    Y.TYPE = "RNC"
    Y.IDEN = R.NEW(REDO.CCRG.CUS.CU.RNC)
    Y.SEL.CMD := " WITH L.CU.RNC EQ " : R.NEW(REDO.CCRG.CUS.CU.RNC)
    AF = REDO.CCRG.CUS.CU.RNC
RETURN
*---------------------------------------------------------------------------------------------------------------------------------------------------
PROCESS.PASS:
*---------------------------------------------------------------------------------------------------------------------------------------------------

    Y.TYPE = "PASSPORT"
    Y.IDEN = R.NEW(REDO.CCRG.CUS.CU.LEGAL.ID)
    Y.SEL.CMD := " WITH LEGAL.ID EQ " : R.NEW(REDO.CCRG.CUS.CU.LEGAL.ID)
    AF = REDO.CCRG.CUS.CU.LEGAL.ID
RETURN
*-----------------------------------------------------------------------------
END

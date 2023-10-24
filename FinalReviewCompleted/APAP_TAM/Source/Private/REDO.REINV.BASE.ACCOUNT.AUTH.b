* @ValidationCode : MjotMTQ5MTQ1NzQ5OTpDcDEyNTI6MTY4MjUyODQ3MjY4ODpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Apr 2023 22:31:12
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
SUBROUTINE REDO.REINV.BASE.ACCOUNT.AUTH

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.REINV.BASE.ACCOUNT.AUTH

*--------------------------------------------------------------------------------
* Description: This Auth routine is too store value for next version (AZ.ACCOUNT)
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 04-Jul-2011     H GANESH    PACS00072695_N.11   INITIAL CREATION
*
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           FM TO @FM, VM TO @VM
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------------
 
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.PRODUCT.PARAMETER

    GOSUB INIT
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

    FN.APP = 'F.AZ.PRODUCT.PARAMETER'
    F.APP = ''
    CALL OPF(FN.APP,F.APP)


    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    LOC.REF.APPLICATION="ACCOUNT":@FM:"AZ.PRODUCT.PARAMETER"
    LOC.REF.FIELDS='L.AZ.APP':@VM:'L.AC.AZ.ACC.REF':@VM:'L.AC.STATUS1':@FM:'L.AZ.RE.INV.CAT'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)

    POS.L.AZ.APP        = LOC.REF.POS<1,1>
    POS.L.AC.AZ.ACC.REF = LOC.REF.POS<1,2>
    POS.L.AC.STATUS1    = LOC.REF.POS<1,3>
    POS.L.AZ.RE.INV.CAT = LOC.REF.POS<2,1>

RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
    Y.APP.ID = R.NEW(AC.LOCAL.REF)<1,POS.L.AZ.APP>
    CALL System.setVariable("CURRENT.APP.ID",Y.APP.ID)

    GOSUB POST.OFS

RETURN
*---------------------------------------------------------------------------------
POST.OFS:
*---------------------------------------------------------------------------------

    CALL CACHE.READ(FN.APP,Y.APP.ID,R.APP,APP.ERR)

    VAR.NEW.ACCT.HOLD = R.NEW(AC.JOINT.HOLDER)
    VAR.NEW.REL.CODE  = R.NEW(AC.RELATION.CODE)
    VAR.NEW.JOINT.NOTES = R.NEW(AC.JOINT.NOTES)

    VAR.OLD.ACCT.HOLD = R.OLD(AC.JOINT.HOLDER)
    VAR.OLD.REL.CODE  = R.OLD(AC.RELATION.CODE)
    VAR.OLD.JOINT.NOTES = R.OLD(AC.JOINT.NOTES)


    VAR.OLD.CURR.NO = R.OLD(AC.CURR.NO)

    IF NOT(VAR.OLD.CURR.NO) THEN
        R.ACCOUNT   = ''
        R.ACCOUNT<AC.CUSTOMER> = R.NEW(AC.CUSTOMER)
        R.ACCOUNT<AC.CATEGORY> = R.APP<AZ.APP.LOCAL.REF,POS.L.AZ.RE.INV.CAT>
        R.ACCOUNT<AC.CURRENCY> = R.NEW(AC.CURRENCY)
        R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.AZ.ACC.REF> = ID.NEW
        R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.STATUS1> = 'ACTIVE'
        R.ACCOUNT<AC.JOINT.HOLDER>  = VAR.NEW.ACCT.HOLD
        R.ACCOUNT<AC.RELATION.CODE> = VAR.NEW.REL.CODE
        R.ACCOUNT<AC.JOINT.NOTES>   = VAR.NEW.JOINT.NOTES

        APPLICATION.NAME = 'ACCOUNT'
        OFS.FUNCTION1 = 'I'
        PROCESS1 = 'PROCESS'
        OFS.VERSION1 = ''
        GTSMODE1 = ''
        NO.OF.AUTH1 = '0'
        TRANSACTION.ID1 = ''
        OFS.RECORD1 = ''
        VERSION1 = 'ACCOUNT,REINV.INT.LIQ'
        MSG.ID1 = ''
        OPTION1 = ''

        CALL OFS.BUILD.RECORD(APPLICATION.NAME,OFS.FUNCTION1,PROCESS1,VERSION1,GTSMODE1,NO.OF.AUTH1,TRANSACTION.ID1,R.ACCOUNT,OFS.ACC)
        MSG.ID = ''
        ERR.OFS = ''
        OFS.SRC.ID = 'REINV.DEPOSIT'
        CALL OFS.POST.MESSAGE(OFS.ACC,MSG.ID,OFS.SRC.ID,ERR.OFS)
    END ELSE
        IF (VAR.OLD.ACCT.HOLD NE VAR.NEW.ACCT.HOLD) OR (VAR.OLD.REL.CODE NE VAR.NEW.REL.CODE) OR (VAR.OLD.JOINT.NOTES NE VAR.NEW.JOINT.NOTES) THEN
            TRANSACTION.ID1 = R.NEW(AC.INTEREST.LIQU.ACCT)
            CALL F.READ(FN.ACCOUNT,TRANSACTION.ID1,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
            R.ACCOUNT<AC.JOINT.HOLDER>  = VAR.NEW.ACCT.HOLD
            R.ACCOUNT<AC.RELATION.CODE> = VAR.NEW.REL.CODE
            R.ACCOUNT<AC.JOINT.NOTES>   = VAR.NEW.JOINT.NOTES

            APPLICATION.NAME = 'ACCOUNT'
            OFS.FUNCTION1 = 'I'
            PROCESS1 = 'PROCESS'
            OFS.VERSION1 = ''
            GTSMODE1 = ''
            NO.OF.AUTH1 = '0'
            TRANSACTION.ID1 = R.NEW(AC.INTEREST.LIQU.ACCT)
            OFS.RECORD1 = ''
            VERSION1 = 'ACCOUNT,REINV.INT.LIQ'
            MSG.ID1 = ''
            OPTION1 = ''
            CALL OFS.BUILD.RECORD(APPLICATION.NAME,OFS.FUNCTION1,PROCESS1,VERSION1,GTSMODE1,NO.OF.AUTH1,TRANSACTION.ID1,R.ACCOUNT,OFS.ACC)
            MSG.ID = ''
            ERR.OFS = ''
            OFS.SRC.ID = 'REINV.DEPOSIT'
            CALL OFS.POST.MESSAGE(OFS.ACC,MSG.ID,OFS.SRC.ID,ERR.OFS)
        END

    END

RETURN
END

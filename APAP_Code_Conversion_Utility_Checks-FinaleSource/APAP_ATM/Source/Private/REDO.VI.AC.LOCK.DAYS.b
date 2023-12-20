* @ValidationCode : MjotNjEwNTc1ODQ0OkNwMTI1MjoxNzAyOTg4MjUxNTU1OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:47:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM

SUBROUTINE REDO.VI.AC.LOCK.DAYS
***********************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :DHAMU.S
*  Program   Name    :REDO.VI.AC.LOCK.DAYS

*-----------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
* DESCRIPTION       :This routine is used to lock the transaction amount for
*                    N number of days based on parameter set in REDO.H.PARAMETER
*

*------------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE            WHO             REFERENCE         DESCRIPTION
*  23-Nov-2010     Dhamu.S                         INITIAL CREATION
* 15 Nov 2011      Kavitha         PACS00137917    PACS00137917 fix
* 11.04.2023      Conversion Tool       R22        Auto Conversion     - No changes
* 11.04.2023      Shanmugapriya M       R22        Manual Conversion   - No changes
*
*-------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.REDO.APAP.H.PARAMETER
    $INSERT I_REDO.TELLER.COMMON
    $INSERT I_F.ACCOUNT
   

    IF V$FUNCTION EQ 'R' THEN
        RETURN
    END

    GOSUB INIT
    GOSUB PROCESS

RETURN

*****
INIT:
*****

    FN.REDO.APAP.H.PARAMETER = 'F.REDO.APAP.H.PARAMETER'
    F.REDO.APAP.H.PARAMETER = ''
    CALL OPF(FN.REDO.APAP.H.PARAMETER,F.REDO.APAP.H.PARAMETER)


    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    APL.ARRAY = "ACCOUNT"
    APL.FIELD = 'L.AC.AV.BAL'
    FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APL.ARRAY,APL.FIELD,FLD.POS)
    LOC.L.AC.AV.BAL.POS = FLD.POS<1,1>

    LCK.DAYS = ''

RETURN

*******
PROCESS:
*******

    SEL.ID = 'SYSTEM'

    CALL CACHE.READ(FN.REDO.APAP.H.PARAMETER,SEL.ID,R.REDO.APAP.H.PARAMETER,PARA.ERR)

    LOCK.DAYS = R.REDO.APAP.H.PARAMETER<PARAM.LOCK.DAYS>
    LCK.DAYS = "+":LOCK.DAYS:"C"
    DATE.FRM = TODAY
    CALL CDT('',DATE.FRM,LCK.DAYS)
    R.NEW(AC.LCK.TO.DATE)=DATE.FRM

    Y.ACCOUNT.NO = COMI
    IF Y.ACCOUNT.NO[1,3] MATCHES '3A' THEN
        RETURN
    END

    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.NO,R.ACCOUNT,F.ACCOUNT,DEB.ERR)
    IF R.ACCOUNT EQ '' THEN
        RETURN
    END
    L.AC.AV.BALANCE = R.ACCOUNT<AC.LOCAL.REF,LOC.L.AC.AV.BAL.POS>

RETURN
********************************************************************************
END
*--------------End of Program---------------------------------------------------------

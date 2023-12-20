* @ValidationCode : Mjo1MjI4MjEyNjI6Q3AxMjUyOjE2OTc3MTc4ODQ1MDE6SVRTUzotMTotMTo5ODQ6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Oct 2023 17:48:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 984
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOCHNLS

SUBROUTINE REDO.ATH.STLMT.FILE.PROCESS.LOAD
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.ATH.STLMT.FILE.PROCESS.LOAD
*Date              : 6.12.2010
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*06/12/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
* 04-APR-2023     Conversion tool            R22 Auto conversion    FM TO @FM, VM to @VM
* 04-APR-2023      Harishvikram C            Manual R22 conversion     No changes
* 17/10/2023	   VIGNESHWARI       ADDED COMMENT FOR ATM CHANGES   ATM changes by Mario

*------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.ATH.STLMT.FILE.PROCESS.COMMON
    $INSERT I_F.REDO.DC.STLMT.ERR.CODE

    GOSUB OPEN.FILES
    GOSUB READING
RETURN
*------------------------------------------------------------------------------------
OPEN.FILES:
*------------------------------------------------------------------------------------

    FN.REDO.ATH.STLMT.CNCT.FILE='F.REDO.ATH.STLMT.CNCT.FILE'
    F.REDO.ATH.STLMT.CNCT.FILE=''
    CALL OPF(FN.REDO.ATH.STLMT.CNCT.FILE,F.REDO.ATH.STLMT.CNCT.FILE)

    FN.REDO.ATH.STLMT.MAPPING='F.REDO.ATH.STLMT.MAPPING'
    F.REDO.ATH.STLMT.MAPPING=''
    CALL OPF(FN.REDO.ATH.STLMT.MAPPING,F.REDO.ATH.STLMT.MAPPING)


    FN.CARD.TYPE='F.CARD.TYPE'
    F.CARD.TYPE=''
    CALL OPF(FN.CARD.TYPE,F.CARD.TYPE)

    FN.REDO.CARD.BIN='F.REDO.CARD.BIN'
    F.REDO.CARD.BIN=''
    CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)

    FN.LATAM.CARD.ORDER='F.LATAM.CARD.ORDER'
    F.LATAM.CARD.ORDER=''
    CALL OPF(FN.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER)

    FN.REDO.MERCHANT.CATEG='F.REDO.MERCHANT.CATEG'
    F.REDO.MERCHANT.CATEG=''
    CALL OPF(FN.REDO.MERCHANT.CATEG,F.REDO.MERCHANT.CATEG)

    FN.ATM.TRANSACTION='F.ATM.TRANSACTION'  ;* ATM changes by Mario-START
    F.ATM.TRANSACTION=''
    CALL OPF(FN.ATM.TRANSACTION,F.ATM.TRANSACTION)   ;* ATM changes by Mario-END

    FN.AC.LOCKED.EVENTS='F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS=''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.STLMT.POSTED.LOG='F.STLMT.POSTED.LOG'
    F.STLMT.POSTED.LOG=''
    CALL OPF(FN.STLMT.POSTED.LOG,F.STLMT.POSTED.LOG)

    FN.REDO.DC.STLMT.ERR.CODE='F.REDO.DC.STLMT.ERR.CODE'
    F.REDO.DC.STLMT.ERR.CODE=''


    FN.REDO.APAP.H.PARAMETER='F.REDO.APAP.H.PARAMETER'
    FN.REDO.ATH.STLMT.PARAM='F.REDO.ATH.STLMT.PARAM'

RETURN

*---------------------------------------------------------------------------------
READING:
*----------------------------------------------------------------------------------
    REDO.ID='SYSTEM'
    CALL CACHE.READ(FN.REDO.ATH.STLMT.PARAM,REDO.ID,R.REDO.ATH.STLMT.PARAM,REDO.ERR)
    CALL CACHE.READ(FN.REDO.APAP.H.PARAMETER,REDO.ID,R.REDO.APAP.H.PARAMETER,REDO.H.ERR)
    CALL CACHE.READ(FN.REDO.DC.STLMT.ERR.CODE,'SYSTEM',R.REDO.DC.STLMT.ERR.CODE,REDO.STLMT.ERR)

    LOC.REF.APPLICATION="FUNDS.TRANSFER":@FM:'ACCOUNT':@FM:'AC.LOCKED.EVENTS'
    LOC.REF.FIELDS='AT.UNIQUE.ID':@VM:'POS.COND':@VM:'BIN.NO':@VM:'AT.AUTH.CODE':@VM:'ATM.TERM.ID':@VM:'L.STLMT.ID':@VM:'L.STLMT.APPL':@FM:'L.AC.AV.BAL':@FM:'L.TXN.AMT':@VM:'L.TXN.CHG.LOCAL'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.AT.UNIQUE.ID=LOC.REF.POS<1,1>
    POS.POS.COND=LOC.REF.POS<1,2>
    POS.BIN.NO=LOC.REF.POS<1,3>
    POS.AT.AUTH.CODE=LOC.REF.POS<1,4>
    POS.ATM.TERM.ID=LOC.REF.POS<1,5>
    POS.L.STLMT.ID=LOC.REF.POS<1,6>
    POS.L.STLMT.APPL=LOC.REF.POS<1,7>
    POS.L.AC.AV.BAL = LOC.REF.POS<2,1>
    POS.L.TXN.AMT=LOC.REF.POS<3,1>
    POS.L.TXN.CHG.LOCAL=LOC.REF.POS<3,2>

RETURN
END

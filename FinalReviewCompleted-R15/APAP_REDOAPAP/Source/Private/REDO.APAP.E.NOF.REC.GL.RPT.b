* @ValidationCode : MjoxMDU3MjMyMzc5OkNwMTI1MjoxNjkwMTY4NTEyMDgwOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:45:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.E.NOF.REC.GL.RPT(Y.OUT.ARRAY)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.E.NOF.SAP.GL.RPT
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.E.NOF.SAP.GL.RPT is a no-file enquiry routine for the enquiry
*                    REDO.APAP.E.NOF.SAP.GL.RPT, the routine based on the selection criteria
*                    selects the records from REDO.H.CUSTOMER.PROVISION and displays the processed records
*Linked With       : Enquiry - REDO.E.NOF.SAP.GL.RPT
*In  Parameter     : NA
*Out Parameter     : Y.OUT.ARRAY - Final list of records to be displayed
*Files  Used       : REDO.GL.H.EXTRACT.PARAMETER             As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date                 Who                     Reference                  Description
*   ------               ------                  -------------               -------------
* 07-08-2012           GANESH R                 PACS00208725                3DES ENCRYPTION
* Date                   who                   Reference
* 05-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION SM TO @SM VM TO @VM AND FM TO @FM AND ++ TO  += 1 AND F.READ TO CACHE.READ AND REMOVING F.MNEMONIC.COMPANY
* 05-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.MNEMONIC.COMPANY
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TRANSACTION
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.REC.ACCT.LIST.COMMON
	$USING APAP.REDOSRTN

*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    Y.CUR.SEL.LIST =''
    Y.ACC.SEL.LIST =''
    Y.COMP.SEL.LIST=''
    Y.CATEG.LIST   =''
    Y.LINE.SEL.LIST=''
    Y.VALD.SEL.LIST=''
    Y.BKD.SEL.LIST =''
    Y.DLM='*'
    GOSUB PROCESS
RETURN
********
PROCESS:
********

    LOCATE 'CURRENCY' IN D.FIELDS<1> SETTING Y.CUR.POS THEN
        Y.CUR.SEL.LIST = D.RANGE.AND.VALUE<Y.CUR.POS>
        Y.CLASS.DATA   =Y.CUR.SEL.LIST
        CHANGE @SM TO ' ' IN Y.CLASS.DATA
        Y.CLASS='CURRENCY:':Y.CLASS.DATA
    END
    LOCATE 'ACCOUNT.ID' IN D.FIELDS<1> SETTING Y.ACCT.POS THEN
        Y.ACC.SEL.LIST = D.RANGE.AND.VALUE<Y.ACCT.POS>
        Y.CLASS.DATA   =Y.ACC.SEL.LIST
        CHANGE @SM TO ' ' IN Y.CLASS.DATA
        Y.CLASS=Y.CLASS:'ACCOUNT.ID:':Y.CLASS.DATA
    END
    LOCATE 'COMPANY.CODE' IN D.FIELDS<1> SETTING Y.CMP.POS THEN
        Y.COMP.SEL.LIST= D.RANGE.AND.VALUE<Y.CMP.POS>
        Y.CLASS.DATA   =Y.COMP.SEL.LIST
        CHANGE @SM TO ' ' IN Y.CLASS.DATA
        Y.CLASS=Y.CLASS:'COMPANY.CODE:':Y.CLASS.DATA
    END
    LOCATE 'CATEGORY' IN D.FIELDS<1> SETTING Y.CAT.POS THEN
        Y.CATEG.LIST   = D.RANGE.AND.VALUE<Y.CAT.POS>
        Y.CLASS.DATA   =Y.CATEG.LIST
        CHANGE @SM TO ' ' IN Y.CLASS.DATA
        Y.CLASS=Y.CLASS:'CATEGORY:':Y.CLASS.DATA
    END
    LOCATE 'LINE' IN D.FIELDS<1> SETTING Y.LINE.POS THEN
        Y.LINE.SEL.LIST= D.RANGE.AND.VALUE<Y.LINE.POS>
        Y.CLASS.DATA=Y.LINE.SEL.LIST
        CHANGE @SM TO ' ' IN Y.CLASS.DATA
        Y.CLASS=Y.CLASS:'LINE:':Y.CLASS.DATA
    END
    LOCATE 'VALUE.DATE' IN D.FIELDS<1> SETTING Y.VALD.POS THEN
        Y.VALD.SEL.LIST= D.RANGE.AND.VALUE<Y.VALD.POS>
        Y.CLASS.DATA=Y.VALD.SEL.LIST
        CHANGE @SM TO ' ' IN Y.CLASS.DATA
        Y.CLASS=Y.CLASS:'VALUE.DATE:':Y.CLASS.DATA
    END
    LOCATE 'BOOKING.DATE' IN D.FIELDS<1> SETTING Y.BD.POS THEN
        Y.REP.DATE     = D.RANGE.AND.VALUE<Y.BD.POS>
        Y.REP.OPERAND=D.LOGICAL.OPERANDS<Y.BD.POS>
        Y.CLASS.DATA=Y.REP.DATE
        CHANGE @SM TO ' ' IN Y.CLASS.DATA
        Y.CLASS=Y.CLASS:'BOOKING.DATE:':Y.CLASS.DATA
    END

    FN.RHRP='F.REDO.H.REPORTS.PARAM'
    F.RHRP =''
    CALL OPF(FN.RHRP,F.RHRP)

    FN.ACCOUNT ='F.ACCOUNT'
    F.ACCOUNT  =''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.STMT.ENTRY='F.STMT.ENTRY'
    F.STMT.ENTRY =''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)

    FN.MNEMONIC.COMPANY='F.MNEMONIC.COMPANY'
    F.MNEMONIC.COMPANY =''
    CALL OPF(FN.MNEMONIC.COMPANY,F.MNEMONIC.COMPANY)

    FN.FT='F.FUNDS.TRANSFER'
    F.FT =''
    CALL OPF(FN.FT,F.FT)

    FN.TT='F.TELLER'
    F.TT =''
    CALL OPF(FN.TT,F.TT)

    FN.TFS='F.T24.FUND.SERVICES'
    F.TFS =''
    CALL OPF(FN.TFS,F.TFS)

    FN.FX='F.FOREX'
    F.FX =''
    CALL OPF(FN.FX,F.FX)

    FN.TT.HIS='F.TELLER$HIS'
    F.TT.HIS =''
    CALL OPF(FN.TT.HIS,F.TT.HIS)

    FN.FT.HIS='F.FUNDS.TRANSFER$HIS'
    F.FT.HIS =''
    CALL OPF(FN.FT.HIS,F.FT.HIS)

    FN.FX.HIS='F.FOREX$HIS'
    F.FX.HIS =''
    CALL OPF(FN.FX.HIS,F.FX.HIS)

    FN.EB.CONT.BAL.CA='F.EB.CONTRACT.BALANCES'
    F.EB.CONT.BAL.CA =''
    CALL OPF(FN.EB.CONT.BAL.CA,F.EB.CONT.BAL.CA)

    FN.RE.STAT.REP.LINE.CA='F.RE.STAT.REP.LINE'
    F.RE.STAT.REP.LINE.CA =''
    CALL OPF(FN.RE.STAT.REP.LINE.CA,F.RE.STAT.REP.LINE.CA)

    FN.FTTC='F.FT.TXN.TYPE.CONDITION'
    F.FTTC =''
    CALL OPF(FN.FTTC,F.FTTC)

    FN.TT.TXN='F.TELLER.TRANSACTION'
    F.TT.TXN =''
    CALL OPF(FN.TT.TXN,F.TT.TXN)

    FN.TXN='F.TRANSACTION'
    F.TXN =''
    CALL OPF(FN.TXN,F.TXN)

    FN.ACCT.EL.DAY='F.ACCT.ENT.LWORK.DAY'
    F.ACCT.EL.DAY =''
    CALL OPF(FN.ACCT.EL.DAY,F.ACCT.EL.DAY)

    CALL F.READ(FN.RHRP,'RECONRPT',R.RHRP,F.RHRP,ERR)

    Y.FIELD.LIST=R.RHRP<REDO.REP.PARAM.FIELD.NAME>
    Y.VALUE.LIST=R.RHRP<REDO.REP.PARAM.FIELD.VALUE>
    LOCATE 'DEF.ST.CATEG' IN Y.FIELD.LIST<1,1> SETTING Y.DEF.ST.CATEG.POS THEN
        DEF.ST.CATEG=Y.VALUE.LIST<1,Y.DEF.ST.CATEG.POS>
    END
    LOCATE 'DEF.ED.CATEG' IN Y.FIELD.LIST<1,1> SETTING Y.DEF.ED.CATEG.POS THEN
        DEF.ED.CATEG=Y.VALUE.LIST<1,Y.DEF.ED.CATEG.POS>
    END

    SEL.CMD.MNE = 'SELECT ': FN.MNEMONIC.COMPANY
    CALL EB.READLIST(SEL.CMD.MNE,Y.COMPANY.MNE.LIST,'',NO.OF.REC.MNE,SEL.ERR)
    Y.COMPANY.LIST=''
    LOOP
        REMOVE Y.COMPANY.MNE.ID FROM Y.COMPANY.MNE.LIST SETTING Y.COMPANY.MNE.POS
    WHILE Y.COMPANY.MNE.ID:Y.COMPANY.MNE.POS
        CALL CACHE.READ(FN.MNEMONIC.COMPANY, Y.COMPANY.MNE.ID, R.MNEMONIC.COMPANY, ERR) ;*R22 AUTO CONVERSTION F.READ TO CACHE.READ AND REMOVING F.MNEMONIC.COMPANY

        Y.COMPANY.LIST<-1>= R.MNEMONIC.COMPANY<AC.MCO.COMPANY>
    REPEAT

    LF.APP = 'TELLER':@FM:'FUNDS.TRANSFER':@FM:'FOREX':@FM:'T24.FUND.SERVICES':@FM:'SEC.TRADE'
    LF.FLD = 'L.ACTUAL.VERSIO':@VM:'L.COMMENTS':@FM:'L.ACTUAL.VERSIO':@VM:'L.COMMENTS':@FM:'L.ACTUAL.VERSIO':@FM:'L.COMMENTS':@FM:'L.COMMENTS'
    LF.POS = ''
    CALL MULTI.GET.LOC.REF(LF.APP,LF.FLD,LF.POS)
    Y.TT.ACT.VER.POS=LF.POS<1,1>
    Y.TT.LOC.CMT.POS=LF.POS<1,2>
    Y.FT.ACT.VER.POS=LF.POS<2,1>
    Y.FT.LOC.CMT.POS=LF.POS<2,2>
    Y.FX.ACT.VER.POS=LF.POS<3,1>
    Y.TF.LOC.CMT.POS=LF.POS<4,1>
    Y.ST.LOC.CMT.POS=LF.POS<5,1>

    SEL.CMD = 'SELECT ': FN.ACCOUNT :" WITH CATEGORY GE ":DEF.ST.CATEG:" AND CATEGORY LE ":DEF.ED.CATEG
    CALL EB.READLIST(SEL.CMD,Y.ACCT.LIST,'',NO.OF.REC.RE,SEL.ERR)
    Y.LOOP.CNT=1
    LOOP
    WHILE Y.LOOP.CNT LE NO.OF.REC.RE
*       CALL REDO.S.REC.ACCT.LIST(Y.ACCT.LIST<Y.LOOP.CNT>,Y.FIN.ARRAY)
        APAP.REDOSRTN.redoSRecAcctList(Y.ACCT.LIST<Y.LOOP.CNT>,Y.FIN.ARRAY);* R22 Manual conversion

        IF Y.FIN.ARRAY THEN
            Y.OUT.ARRAY<-1>=Y.FIN.ARRAY
        END
        Y.LOOP.CNT += 1 ;*R22 AUTO CONVERSTION ++ TO += 1
    REPEAT


    Y.REC.COUNT = DCOUNT(Y.OUT.ARRAY,@FM)
    Y.REC.START = 1
    LOOP
    WHILE Y.REC.START LE Y.REC.COUNT
        Y.REC.LINE = Y.OUT.ARRAY<Y.REC.START>
        Y.COMP.ID  = FIELD(Y.REC.LINE,Y.DLM,2)
        IF NOT(Y.COMP.ID) THEN
            Y.COMP.ID  =FIELD(Y.REC.LINE,Y.DLM,3)
        END
        Y.SORT.VAL = FIELD(Y.REC.LINE,Y.DLM,1):Y.COMP.ID:FIELD(Y.REC.LINE,Y.DLM,6):FIELD(Y.REC.LINE,Y.DLM,5)
        Y.REC.SORT.LIST<-1> = Y.REC.LINE:@FM:Y.SORT.VAL
        Y.SORT.LIST<-1> = Y.SORT.VAL
        Y.REC.START += 1
    REPEAT

    Y.SORT.LIST = SORT(Y.SORT.LIST)

    LOOP
        REMOVE Y.SORTED.VAL FROM Y.SORT.LIST SETTING Y.SORT.POS
    WHILE Y.SORTED.VAL : Y.SORT.POS
        LOCATE Y.SORTED.VAL IN Y.REC.SORT.LIST SETTING Y.LOC.POS THEN
            Y.SORTED.REC<-1> = Y.REC.SORT.LIST<Y.LOC.POS-1>
            DEL Y.REC.SORT.LIST<Y.LOC.POS>
            DEL Y.REC.SORT.LIST<Y.LOC.POS-1>
        END
    REPEAT

    Y.OUT.ARRAY=Y.SORTED.REC:Y.DLM:Y.CLASS
RETURN
END

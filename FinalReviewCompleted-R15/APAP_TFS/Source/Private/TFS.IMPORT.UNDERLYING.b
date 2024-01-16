* @ValidationCode : Mjo5MDU5NzE5OTc6Q3AxMjUyOjE3MDQ5NzI0NDIxNDc6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Jan 2024 16:57:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TFS
*-----------------------------------------------------------------------------
* <Rating>1857</Rating>
*-----------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Ajithkumar             R22 Manual Conversion      GLOBUS.BP ,USPLATFORM.BP File is Removed,FM, VM , to @FM, @VM, Call Rtn Format Modified
*

SUBROUTINE TFS.IMPORT.UNDERLYING(DEFAULTED.FIELD,DEFAULTED.ENRI)
*
* Subroutine Type : Generic
* Attached to     : Invoked from T24.FS.CHECK.FIELDS if there is an input in UNDERLYING field.
* Attached as     : N/A
* Primary Purpose : Looks up either TELLER or FT to load the underlying transaction and
*                   populates all the details of the transaction.
*
* Incoming:
* ---------
* None
*
* Outgoing:
* ---------
* None
*
* Error Variables:
* ----------------
* None
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* 06/09/05 - Sathish PS
*            New Development
*
* 07/14/05 - GP
*            Modified CHECK.PRELIM.CONDS to avoid deletion of DC id during authorize
*            inserted condition  Don't clear R.UNDERLYING from INAU to AUTH
*
* 22 NOV 2006 - Sesh V.S
*             - Code amended to cater to taking the date from original transaction
*
* 15 DEC 2006 - Sesh V.S
*             - Code amended so that the credit to the suspense account during DC
*             - creation has a exposure date as TODAY (immediate effect) while the
*             - debit to member account is done with a future exposure date.
*-----------------------------------------------------------------------------------
    $INCLUDE  I_COMMON ; *R22 Manual Code conversion - start
    $INCLUDE  I_EQUATE

    $INCLUDE  I_GTS.COMMON
    $INCLUDE  I_F.FUNDS.TRANSFER
    $INCLUDE  I_F.TELLER
    $INCLUDE  I_F.ACCOUNT

    $INCLUDE  I_F.T24.FUND.SERVICES
    $INCLUDE  I_T24.FS.COMMON ; *R22 Manual Code conversion - end

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN
*-----------------------------------------------------------------------------------
PROCESS:

    BEGIN CASE
        CASE COMI[1,2] EQ 'TT'
            GOSUB IMPORT.FROM.TT
        CASE COMI[1,2] EQ 'FT'
            GOSUB IMPORT.FROM.FT
        CASE OTHERWISE
    END CASE

RETURN
*-----------------------------------------------------------------------------------
IMPORT.FROM.TT:
    BEGIN CASE
        CASE  R.UL<TT.TE.DR.CR.MARKER> EQ 'DEBIT'
            DR.AC = R.UL<TT.TE.ACCOUNT.1> ; CR.AC = R.UL<TT.TE.ACCOUNT.2>
            DR.CCY = R.UL<TT.TE.CURRENCY.1> ; CR.CCY = R.UL<TT.TE.CURRENCY.2>
            DR.VAL.DATE = R.UL<TT.TE.VALUE.DATE.1> ; CR.VAL.DATE = R.UL<TT.TE.VALUE.DATE.2>
            !DR.EXP.DATE = R.UL<TT.TE.EXPOSURE.DATE.1> ;!CR.EXP.DATE = R.UL<TT.TE.EXPOSURE.DATE.2> ; * 22 NOV 2006 - Sesh V.S /s
            CR.EXP.DATE = R.UL<TT.TE.EXP.SPT.DAT>
            CONVERT @SM TO @FM IN CR.EXP.DATE
            !IF DR.EXP.DATE LT TODAY THEN DR.EXP.DATE = TODAY ; * 22 NOV 2006 - Sesh V.S /s
            !IF CR.EXP.DATE LT TODAY THEN CR.EXP.DATE = TODAY  ; * 22 NOV 2006 - Sesh V.S /e
            EXP.DATE.CNT = DCOUNT(CR.EXP.DATE,@FM)
            CR.EXP.DATE = R.UL<TT.TE.EXP.SPT.DAT,AV,EXP.DATE.CNT>
            SAVE.CR.EXP.DATE = '' ; SAVE.CR.EXP.DATE = CR.EXP.DATE
            DR.EXP.DATE = CR.EXP.DATE ; * 15 DEC 2006 - Sesh V.S /s
            CR.EXP.DATE = TODAY ; * 15 DEC 2006 - Sesh V.S /e
        CASE R.UL<TT.TE.DR.CR.MARKER> EQ 'CREDIT'
            DR.AC = R.UL<TT.TE.ACCOUNT.2> ; CR.AC = R.UL<TT.TE.ACCOUNT.1>
            DR.CCY = R.UL<TT.TE.CURRENCY.2> ; CR.CCY = R.UL<TT.TE.CURRENCY.1>
            DR.VAL.DATE = R.UL<TT.TE.VALUE.DATE.2> ; CR.VAL.DATE = R.UL<TT.TE.VALUE.DATE.1>
            ! DR.EXP.DATE = R.UL<TT.TE.EXPOSURE.DATE.2> ; CR.EXP.DATE = R.UL<TT.TE.EXPOSURE.DATE.1>
            CR.EXP.DATE = R.UL<TT.TE.EXP.SPT.DAT>
            CONVERT @SM TO @FM IN CR.EXP.DATE
            EXP.DATE.CNT = DCOUNT(CR.EXP.DATE,@FM)
            CR.EXP.DATE = R.UL<TT.TE.EXP.SPT.DAT,AV,EXP.DATE.CNT>
            !DR.EXP.DATE = CR.EXP.DATE       ;* 22 NOV 2006 - Sesh V.S /e
            DR.EXP.DATE = R.UL<TT.TE.VALUE.DATE.1> ; * 15 DEC 2006 - Sesh V.S - s/e

        CASE OTHERWISE
    END CASE

** 15 DEC 2006 - /S
    !IF DR.CCY EQ LCCY THEN AMT = R.UL<TT.TE.AMOUNT.LOCAL.1> ELSE AMT = R.UL<TT.TE.AMOUNT.FCY.1>
    IF DR.CCY EQ LCCY THEN
        YHELD.AMT = 0 ; YCR.EXP.DATE = '' ; AMT = 0
        CALL F.READ.HISTORY(FN.TT.HIS,YREV.TXN.ID,R.TT.HIS,F.TT.HIS,ERR.TT.HIS)
        IF R.TT.HIS THEN
            FOR X = 1 TO EXP.DATE.CNT
                YEXP.DATE = R.TT.HIS<TT.TE.EXP.SPT.DAT,AV,X>
                IF YEXP.DATE GT TODAY THEN
                    AMT += R.TT.HIS<TT.TE.EXP.SPT.AMT,AV,X>
                END
            NEXT X
        END
    END ELSE
        AMT = R.UL<TT.TE.AMOUNT.FCY.1>
    END


**** 15 DEC 2006 - /E
*
    IF DR.AC AND CR.AC THEN
        INTERFACE.TO = 'TT' ; INTERFACE.AS = R.UL<TT.TE.TRANSACTION.CODE>
        CHQ.TYPE = R.UL<TT.TE.CHEQ.TYPE> ; CHQ.NO = R.UL<TT.TE.CHEQUE.NUMBER>
        REC.STATUS = R.UL<TT.TE.RECORD.STATUS>
        IF REC.STATUS EQ 'MAT' THEN REC.STATUS = ''
        STMT.NOS = R.UL<TT.TE.STMT.NO>
        UL.COMPANY = R.UL<TT.TE.CO.CODE>
        GOSUB IMPORT.FIELDS
        R.NEW(TFS.CR.DENOM)<1,AV> = LOWER(R.UL<TT.TE.DENOMINATION>)
        R.NEW(TFS.CR.DEN.UNIT)<1,AV> = LOWER(R.UL<TT.TE.UNIT>)
        R.NEW(TFS.CR.SERIAL.NO)<1,AV> = LOWER(R.UL<TT.TE.SERIAL.NO>)
        R.NEW(TFS.DR.DENOM)<1,AV> = LOWER(R.UL<TT.TE.DR.DENOM>)
        R.NEW(TFS.DR.DEN.UNIT)<1,AV> = LOWER(R.UL<TT.TE.DR.UNIT>)
        R.NEW(TFS.DR.SERIAL.NO)<1,AV> = LOWER(R.UL<TT.TE.DR.SERIAL.NO>)
    END ELSE
        E = 'EB-INVALID.INPUT'
    END
    GOSUB UPD.PRIMARY.CUS.AND.PRIMARY.ACC         ;*GP 08/01/05 s/e
RETURN
*-----------------------------------------------------------------------------------
IMPORT.FROM.FT:

    DR.AC = R.UL<FT.DEBIT.ACCT.NO> ; CR.AC = R.UL<FT.CREDIT.ACCT.NO>
    DR.CCY = R.UL<FT.DEBIT.CURRENCY> ; CR.CCY = R.UL<FT.CREDIT.CURRENCY>
    DR.VAL.DATE = R.UL<FT.DEBIT.VALUE.DATE> ; CR.VAL.DATE = R.UL<FT.CREDIT.VALUE.DATE>
    DR.EXP.DATE = R.UL<FT.EXPOSURE.DATE> ; CR.EXP.DATE = R.UL<FT.EXPOSURE.DATE>
    IF R.UL<FT.DEBIT.AMOUNT> THEN AMT = R.UL<FT.DEBIT.AMOUNT> ELSE AMT = R.UL<FT.CREDIT.AMOUNT>

    IF DR.AC AND CR.AC THEN
        INTERFACE.TO = 'FT' ; INTERFACE.AS = R.UL<FT.TRANSACTION.TYPE>
        CHQ.TYPE = R.UL<FT.CHEQ.TYPE> ; CHQ.NO = R.UL<FT.CHEQUE.NUMBER>
        REC.STATUS = R.UL<FT.RECORD.STATUS>
        STMT.NOS = R.UL<FT.STMT.NOS>
        UL.COMPANY = R.UL<FT.CO.CODE>
        GOSUB IMPORT.FIELDS
    END ELSE
        E = 'EB-INVALID.INPUT'
    END

RETURN
*------------------------------------------------------------------------------------
IMPORT.FIELDS:

    IF INTERFACE.AS AND INTERFACE.TO THEN GOSUB GET.TFS.TXN
*
    BEGIN CASE
        CASE DR.VAL.DATE AND NOT(CR.VAL.DATE)
            CR.VAL.DATE = DR.VAL.DATE
        CASE NOT(DR.VAL.DATE) AND CR.VAL.DATE
            DR.VAL.DATE = CR.VAL.DATE
        CASE NOT(DR.VAL.DATE) AND NOT(CR.VAL.DATE)
            DR.VAL.DATE = TODAY
            CR.VAL.DATE = TODAY
    END CASE
*

    IF NOT(DR.VAL.DATE) THEN DR.VAL.DATE = TODAY
    IF NOT(CR.VAL.DATE) THEN CR.VAL.DATE = TODAY
    IF NOT(E) THEN
        IF DR.CCY EQ CR.CCY THEN
            R.NEW(TFS.ACCOUNT.DR)<1,AV> = DR.AC
            FIELD.TO.DEF = TFS.ACCOUNT.DR :'.': AV ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS
            R.NEW(TFS.ACCOUNT.CR)<1,AV> = CR.AC
            FIELD.TO.DEF = TFS.ACCOUNT.CR :'.': AV ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS
            R.NEW(TFS.CURRENCY)<1,AV> = DR.CCY
            FIELD.TO.DEF = TFS.CURRENCY :'.': AV ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS
            R.NEW(TFS.AMOUNT)<1,AV> = AMT
            FIELD.TO.DEF = TFS.AMOUNT :'.': AV ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS
            R.NEW(TFS.CR.VALUE.DATE)<1,AV> = CR.VAL.DATE
            FIELD.TO.DEF = TFS.CR.VALUE.DATE :'.': AV ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS
            R.NEW(TFS.DR.VALUE.DATE)<1,AV> = DR.VAL.DATE
            FIELD.TO.DEF = TFS.DR.VALUE.DATE :'.': AV ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS
            R.NEW(TFS.CR.EXP.DATE)<1,AV> = CR.EXP.DATE
            FIELD.TO.DEF = TFS.CR.EXP.DATE :'.': AV ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS
            R.NEW(TFS.DR.EXP.DATE)<1,AV> = DR.EXP.DATE
            FIELD.TO.DEF = TFS.DR.EXP.DATE :'.': AV ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS
            R.NEW(TFS.CHQ.TYPE)<1,AV> = CHQ.TYPE
            FIELD.TO.DEF = TFS.CHQ.TYPE :'.': AV ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS
            R.NEW(TFS.CHEQUE.NUMBER)<1,AV> = CHQ.NO
            FIELD.TO.DEF = TFS.CHEQUE.NUMBER :'.': AV ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS
            R.NEW(TFS.UNDERLYING)<1,AV> = ID.UL
            FIELD.TO.DEF = TFS.UNDERLYING :'.': AV ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS
            IF REC.STATUS EQ '' THEN REC.STATUS = 'AUT'
            R.NEW(TFS.UL.STATUS)<1,AV> = REC.STATUS
            FIELD.TO.DEF = TFS.UL.STATUS :'.': AV ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS

            IF STMT.NOS THEN
* CALL TFS.PARSE.STMT.NOS(STMT.NOS,'','','')
                APAP.TFS.tfsParseStmtNos(STMT.NOS,'','','') ;*R22 MANAUAL CODE CONVERSION
                R.NEW(TFS.UL.STMT.NO)<1,AV> = LOWER(STMT.NOS)
                NO.OF.STMTS = DCOUNT(STMT.NOS,@VM)
                FOR SV.CNT = 1 TO NO.OF.STMTS
                    FIELD.TO.DEF = TFS.UL.STMT.NO :'.': AV :'.': SV.CNT ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS
                NEXT SV.CNT

                R.NEW(TFS.UL.COMPANY)<1,AV> = UL.COMPANY
                FIELD.TO.DEF = TFS.UL.COMPANY :'.': AV ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS

                R.NEW(TFS.R.UNDERLYING)<1,AV> = ''
                R.NEW(TFS.R.UL.STATUS)<1,AV> = ''
                R.NEW(TFS.R.UL.STMT.NO)<1,AV> = ''

            END ELSE
                E = 'EB-TFS.DR.CCY.NE.CR.CCY'
            END
        END

        RETURN
*-------------------------------------------------------------------------------------
GET.TFS.TXN:

        TFS.TXN = ''
        SEL.CMD = 'SELECT ':FN.TFS.TXN:' WITH INTERFACE.TO EQ ':INTERFACE.TO
        SEL.CMD := ' AND INTERFACE.AS EQ ':INTERFACE.AS
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,'')
        IF SEL.LIST THEN
            TFS.TXN = SEL.LIST<1>
        END
*
        IF TFS.TXN THEN
*CALL TFS.LOAD.TRANSACTION(TFS.TXN,R.TFS.TXN,'','','')
*            APAP.TFS.tfsLoadTransaction(TFS.TXN,R.TFS.TXN,'','','') ; *R22 Manual Code conversion
            APAP.TFS.t24LoadTransaction(TFS.TXN,R.TFS.TXN,'','','') ; *R22 Manual Code conversion      ;* TSR-734921 fix
            IF R.TFS.TXN THEN
                R.NEW(TFS.TRANSACTION)<1,AV> = TFS.TXN
                TFS$R.TFS.TXN(AV) = R.TFS.TXN
                FIELD.TO.DEF = TFS.TRANSACTION :'.': AV ; ENRI.TO.DEF = '' ; GOSUB APPEND.TO.DEFAULTED.FIELDS
            END
        END ELSE
            E = 'EB-TFS.TXN.CODE.NOT.SETUP.FOR.TFS' :@FM: INTERFACE.TO :'-': INTERFACE.AS ;*R22 Manual Conversion
        END

        RETURN

*-------------------------------------------------------------------------------------
UPD.PRIMARY.CUS.AND.PRIMARY.ACC:
*------------------------------*
        BEGIN CASE

            CASE R.UL<TT.TE.CUSTOMER.1> NE ''
                R.NEW(TFS.PRIMARY.CUSTOMER) = R.UL<TT.TE.CUSTOMER.1>
                R.NEW(TFS.PRIMARY.ACCOUNT)  = R.UL<TT.TE.ACCOUNT.1>
            CASE R.UL<TT.TE.CUSTOMER.2> NE ''
                R.NEW(TFS.PRIMARY.CUSTOMER) = R.UL<TT.TE.CUSTOMER.2>
                R.NEW(TFS.PRIMARY.ACCOUNT)  = R.UL<TT.TE.ACCOUNT.2>
        END CASE











        RETURN          ;*From UPD.PRIMARY.CUS.AND.PRIMARY.ACC
*-------------------------------------------------------------------------------------
APPEND.TO.DEFAULTED.FIELDS:

        IF UNASSIGNED(ENRI.TO.DEF) THEN ENRI.TO.DEF = ''

        IF FIELD.TO.DEF THEN
            LOCATE FIELD.TO.DEF IN DEFAULTED.FIELD<1> SETTING FIELD.POS THEN
                DEFAULTED.ENRI<FIELD.POS> = ENRI.TO.DEF
            END ELSE
                DEFAULTED.FIELD<-1> = FIELD.TO.DEF
                LOCATE FIELD.TO.DEF IN DEFAULTED.FIELD<1> SETTING FIELD.POS THEN
                    DEFAULTED.ENRI<FIELD.POS> = ENRI.TO.DEF
                END
            END
            FIELD.TO.DEF = '' ; ENRI.TO.DEF = ''
        END

        RETURN
*----------------------------------------------------------------------------------------------------------------------------------------
*//////////////////////////////////////////////////////////////////////////////////*
*////////////////P R E  P R O C E S S  S U B R O U T I N E S //////////////////////*
*//////////////////////////////////////////////////////////////////////////////////*
INITIALISE:

        PROCESS.GOAHEAD = 1 ; YREV.TXN.ID = COMI

        RETURN
*-----------------------------------------------------------------------------------
OPEN.FILES:

        FN.AC = 'F.ACCOUNT' ; F.AC = '' ; CALL OPF(FN.AC,F.AC)
        FN.TT = 'F.TELLER' ; F.TT = '' ; CALL OPF(FN.TT,F.TT)
        FN.TT.HIS = FN.TT:'$HIS' ; F.TT.HIS = '' ; CALL OPF(FN.TT.HIS,F.TT.HIS)
        FN.FT = 'F.FUNDS.TRANSFER' ; F.FT = '' ; CALL OPF(FN.FT,F.FT)
        FN.FT.HIS = FN.FT:'$HIS' ; F.FT.HIS = '' ; CALL OPF(FN.FT.HIS,F.FT.HIS)
        FN.TFS.TXN = 'F.TFS.TRANSACTION' ; F.TFS.TXN = '' ; CALL OPF(FN.TFS.TXN,F.TFS.TXN)

        RETURN
*-----------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:

        LOOP.CNT = 1 ; MAX.LOOPS = 5
        LOOP
        WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO

            BEGIN CASE
                CASE LOOP.CNT EQ 1
                    IF NOT(COMI) THEN PROCESS.GOAHEAD = 0 ELSE ID.UL = COMI

                CASE LOOP.CNT EQ 2
                    IF R.OLD(TFS.UNDERLYING)<1,AV> THEN PROCESS.GOAHEAD = 0
                    IF R.NEW(TFS.R.UL.STATUS)<1,AV> THEN PROCESS.GOAHEAD = 0  ;*GP/07/15/05 s/e
                CASE LOOP.CNT EQ 3
                    BEGIN CASE
                        CASE COMI[1,2] EQ 'TT'
                            FN.UL.FILE = FN.TT ; F.UL.FILE = F.TT
                            FN.UL.FILE.HIS = FN.TT.HIS ; F.UL.FILE.HIS = F.TT.HIS
                            TXN.FIELD = FT.TRANSACTION.TYPE ; DR.AC.FIELD = FT.DEBIT.ACCT.NO ; CR.AC.FIELD = FT.CREDIT.ACCT.NO
                            DR.CCY.FIELD = FT.DEBIT.CURRENCY ; CR.CCY.FIELD = FT.CREDIT.CURRENCY
                            RECORD.STATUS.FIELD = FT.RECORD.STATUS ; DR.CR.MARKER.FIELD = ''
                        CASE COMI[1,2] EQ 'FT'
                            FN.UL.FILE = FN.FT ; F.UL.FILE = F.FT
                            FN.UL.FILE.HIS = FN.FT.HIS ; F.UL.FILE.HIS = F.FT.HIS
                            TXN.FIELD = TT.TE.TRANSACTION.CODE ; DR.AC.FIELD = TT.TE.ACCOUNT.1 ; CR.AC.FIELD = TT.TE.ACCOUNT.2
                            DR.CCY.FIELD = TT.TE.CURRENCY.1 ; CR.CCY.FIELD = TT.TE.CURRENCY.2
                            RECORD.STATUS.FIELD = TT.TE.RECORD.STATUS ; DR.CR.MARKER.FIELD = TT.TE.DR.CR.MARKER
                        CASE OTHERWISE
                            E = 'EB-INVALID.INPUT'
                    END CASE

                CASE LOOP.CNT EQ 4
                    CALL F.READ(FN.UL.FILE,ID.UL,R.UL,F.UL.FILE,ERR.UL)
                    IF NOT(R.UL) THEN
                        ID.UL.HIS = ID.UL
                        CALL F.READ.HISTORY(FN.UL.FILE.HIS,ID.UL.HIS,R.UL,F.UL.FILE.HIS,ERR.UL.HIS)
                        IF NOT(R.UL) THEN
                            E = 'EB-TFS.REC.MISS.FILE' :@FM: ID.UL.HIS :@VM: FN.UL.FILE ;*R22 Manual Conversion
                            PROCESS.GOAHEAD = 0
                        END
                    END

                CASE LOOP.CNT EQ 5


            END CASE
            LOOP.CNT += 1
        REPEAT

        RETURN
*-----------------------------------------------------------------------------------
    END

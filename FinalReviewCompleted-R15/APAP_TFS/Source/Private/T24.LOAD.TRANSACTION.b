* @ValidationCode : MjoxMTcxMjU3OTc6Q3AxMjUyOjE3MDQ5ODgyNzY2MzU6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Jan 2024 21:21:16
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
$PACKAGE APAP.TFS
*-----------------------------------------------------------------------------
* <Rating>124</Rating>
*-----------------------------------------------------------------------------

*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Ajithkumar             R22 Manual Conversion        USPLATFORM.BP File is Removed, FM ,VM  to @FM, @VM
*11/01/2024         Harish                 R22 Manual Conversion        Renamed routine from TFS.LOAD.TRANSACTION
*-----------------------------------------------------------------------------
SUBROUTINE T24.LOAD.TRANSACTION(TFS.TXN,R.TFS.TXN,FUT.ARG.1,FUT.ARG.2,FUT.ARG.3)
*
* Subroutine to Read TFS.TRANSACTION table, get the Underlying Module Txn codes (like
* FT.TXN.TYPE.CONDITION or TELLER.TRANSACTION, and load the required variables into
* TFS.TRANSACTION record.
*
* Incoming :
*
* TFS.TXN   - ID to TFS.TRANSACTION record
*
* Outgoing :
*
* R.TFS.TXN - Record of TFS.TRANSACTION, also populated with the required underlying
*             transaction codes and allowed a/cs, currencies etc.
* E         - Any Error Message
*------------------------------------------------------------------------------------
*
* Modification History:
*
* 09/21/04   - Sathish PS
*              New Development
*
* 23 OCT 07 - Sathish PS
*             Currency market fix - load DR.CURR.MKT and CR.CURR.MKT...
*------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TRANSACTION
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.TELLER.TRANSACTION

    $INCLUDE  I_T24.FS.COMMON ; *R22 Manual Code conversion -Start
    $INCLUDE  I_F.TFS.PARAMETER
    $INCLUDE  I_F.TFS.TRANSACTION ; *R22 Manual Code conversion - End

    GOSUB INIT.OPEN.FILES
    GOSUB LOAD.TRANSACTION

RETURN
*-------------------------------------------------------------------------------------
LOAD.TRANSACTION:

    CALL F.READ(FN.TFS.TXN,TFS.TXN,R.TFS.TXN,F.TFS.TXN,ERR.TFS.TXN)
    IF R.TFS.TXN THEN
        GOSUB INITIALISE.R.TFS.TXN
        UL.MODULE = R.TFS.TXN<TFS.TXN.INTERFACE.TO>
        IF UL.MODULE THEN
            BEGIN CASE
                CASE UL.MODULE EQ 'FT'
                    UL.TXN = R.TFS.TXN<TFS.TXN.INTERFACE.AS>
                    IF UL.TXN THEN
                        GOSUB LOAD.FT.TRANSACTION
                    END ELSE
                        E = 'EB-TFS.TXN.INTERFACE.AS.MISS' :@FM: TFS.TXN
                    END

                CASE UL.MODULE EQ 'TT'
                    UL.TXN = R.TFS.TXN<TFS.TXN.INTERFACE.AS>
                    IF UL.TXN THEN
                        GOSUB LOAD.TT.TRANSACTION
                    END ELSE
                        E = 'EB-TFS.TXN.INTERFACE.AS.MISS' :@FM: TFS.TXN
                    END

                CASE UL.MODULE EQ 'DC'
                    GOSUB LOAD.DC.TRANSACTION

            END CASE
        END ELSE
            E = 'EB-TFS.TXN.INTERFACE.TO.MISS' :@FM: TFS.TXN
        END
    END ELSE
        E = 'EB-TFS.REC.MISS.FILE' :@FM: TFS.TXN :@VM: FN.TFS.TXN ;*R22 Manual Conversion
    END

RETURN
*-------------------------------------------------------------------------------------
LOAD.FT.TRANSACTION:

    CALL F.READ(FN.FT.TXN,UL.TXN,R.TFS.UL.TXN,F.FT.TXN,ERR.FT.TXN)
    TFS.UL = 'FT'
    IF R.TFS.UL.TXN THEN
        R.TFS.TXN<TFS.TXN.CR.TXN.CODE> = R.TFS.UL.TXN<FT6.TXN.CODE.CR>
        R.TFS.TXN<TFS.TXN.DR.TXN.CODE> = R.TFS.UL.TXN<FT6.TXN.CODE.DR>
        R.TFS.TXN<TFS.TXN.CR.ALLOWED.AC> = 'ANY'
        R.TFS.TXN<TFS.TXN.DR.ALLOWED.AC> = 'ANY'
        R.TFS.TXN<TFS.TXN.CR.ALLOWED.CCY> = 'ANY'
        R.TFS.TXN<TFS.TXN.DR.ALLOWED.CCY> = 'ANY'
        R.TFS.TXN<TFS.TXN.CR.CATEG> = ''
        R.TFS.TXN<TFS.TXN.DR.CATEG> = ''
        ! 23 OCT 07 - Sathish PS /s
        R.TFS.TXN<TFS.TXN.DR.CURR.MKT> = R.TFS.UL.TXN<FT6.DEFAULT.DEAL.MKT>
        R.TFS.TXN<TFS.TXN.CR.CURR.MKT> = R.TFS.UL.TXN<FT6.DEFAULT.DEAL.MKT>
        ! 23 OCT 07 - Sathish PS /e
        IF NOT(R.TFS.TXN<TFS.TXN.CHARGE>) THEN
            R.TFS.TXN<TFS.TXN.CHARGE> = R.TFS.UL.TXN<FT6.CHARGE.TYPES,1>
        END
    END

RETURN
*-------------------------------------------------------------------------------------
LOAD.TT.TRANSACTION:

    CALL F.READ(FN.TT.TXN,UL.TXN,R.TFS.UL.TXN,F.TT.TXN,ERR.TT.TXN)
    TFS.UL = 'TT'
    LOOP.CNT = 1
    LOOP
    WHILE LOOP.CNT LE 2 AND NOT(E) DO

        BEGIN CASE
            CASE LOOP.CNT EQ 1
                TXN.CODE = R.TFS.UL.TXN<TT.TR.TRANSACTION.CODE.1>
                VALID.ACCOUNTS = R.TFS.UL.TXN<TT.TR.VALID.ACCOUNTS.1>
                VALID.CCY = R.TFS.UL.TXN<TT.TR.VALID.CURRENCIES.1>
                VALID.CATEG = R.TFS.UL.TXN<TT.TR.CAT.DEPT.CODE.1>
                VALID.CURR.MKT = R.TFS.UL.TXN<TT.TR.CURR.MKT.1> ;! 23 OCT 07 - Sathish PS s/e

            CASE LOOP.CNT EQ 2
                TXN.CODE = R.TFS.UL.TXN<TT.TR.TRANSACTION.CODE.2>
                VALID.ACCOUNTS = R.TFS.UL.TXN<TT.TR.VALID.ACCOUNTS.2>
                VALID.CCY = R.TFS.UL.TXN<TT.TR.VALID.CURRENCIES.2>
                VALID.CATEG = R.TFS.UL.TXN<TT.TR.CAT.DEPT.CODE.2>
                VALID.CURR.MKT = R.TFS.UL.TXN<TT.TR.CURR.MKT.2> ;! 23 OCT 07 - Sathish PS s/e

        END CASE

        GOSUB DETERMINE.CR.DR.IND
        IF NOT(E) THEN
            IF DR.CR = 'CR' THEN
                R.TFS.TXN<TFS.TXN.CR.TXN.CODE> = TXN.CODE
                R.TFS.TXN<TFS.TXN.CR.ALLOWED.AC> = VALID.ACCOUNTS
                R.TFS.TXN<TFS.TXN.CR.ALLOWED.CCY> = VALID.CCY
                R.TFS.TXN<TFS.TXN.CR.CATEG> = VALID.CATEG
                R.TFS.TXN<TFS.TXN.CR.CURR.MKT> = VALID.CURR.MKT       ;! 23 OCT 07 - Sathish PS /s
            END ELSE
                R.TFS.TXN<TFS.TXN.DR.TXN.CODE> = TXN.CODE
                R.TFS.TXN<TFS.TXN.DR.ALLOWED.AC> = VALID.ACCOUNTS
                R.TFS.TXN<TFS.TXN.DR.ALLOWED.CCY> = VALID.CCY
                R.TFS.TXN<TFS.TXN.DR.CATEG> = VALID.CATEG
                R.TFS.TXN<TFS.TXN.DR.CURR.MKT> = VALID.CURR.MKT       ;! 23 OCT 07 - Sathish PS /s
            END
        END
        LOOP.CNT += 1
    REPEAT

    IF NOT(R.TFS.TXN<TFS.TXN.CHARGE>) THEN
        R.TFS.TXN<TFS.TXN.CHARGE> = R.TFS.UL.TXN<TT.TR.CHARGE.CODE,1>
    END
*
    R.TFS.TXN<TFS.TXN.TILL.TO.TILL> = R.TFS.UL.TXN<TT.TR.TELLER.TRANSFER>
*
    IF NOT(E) THEN
        BEGIN CASE
            CASE NOT(R.TFS.TXN<TFS.TXN.CR.TXN.CODE>)
                E = 'EB-TFS.UNABLE.TO.DETERMINE.CR.TXN.CODE' :@FM: UL.MODULE :@VM: UL.TXN
            CASE NOT(R.TFS.TXN<TFS.TXN.DR.TXN.CODE>)
                E = 'EB-TFS.UNABLE.TO.DETERMINE.DR.TXN.CODE' :@FM: UL.MODULE :@VM: UL.TXN
        END CASE
    END

RETURN
*-------------------------------------------------------------------------------------
LOAD.DC.TRANSACTION:

    R.TFS.TXN<TFS.TXN.CR.ALLOWED.AC> = 'ANY'
    R.TFS.TXN<TFS.TXN.DR.ALLOWED.AC> = 'ANY'
    R.TFS.TXN<TFS.TXN.CR.ALLOWED.CCY> = 'ANY'
    R.TFS.TXN<TFS.TXN.DR.ALLOWED.CCY> = 'ANY'
    R.TFS.TXN<TFS.TXN.CR.CATEG> = ''
    R.TFS.TXN<TFS.TXN.DR.CATEG> = ''
    R.TFS.TXN<TFS.TXN.CR.TXN.CODE> = R.TFS.TXN<TFS.TXN.DC.TXN.CODE.CR>
    R.TFS.TXN<TFS.TXN.DR.TXN.CODE> = R.TFS.TXN<TFS.TXN.DC.TXN.CODE.DR>

RETURN
*-------------------------------------------------------------------------------------
DETERMINE.CR.DR.IND:

    CALL F.READ(FN.TXN,TXN.CODE,R.TXN,F.TXN,ERR.TXN)
    BEGIN CASE
        CASE R.TXN<AC.TRA.DEBIT.CREDIT.IND> EQ 'CREDIT'
            DR.CR = 'CR'
        CASE R.TXN<AC.TRA.DEBIT.CREDIT.IND> EQ 'DEBIT'
            DR.CR = 'DR'
        CASE OTHERWISE
            E = 'EB-TFS.DR.CR.MARK.NOT.SET' :@FM: TXN.CODE :@VM: TFS.UL :@VM: UL.TXN
    END CASE

RETURN
*------------------------------------------------------------------------------------
INITIALISE.R.TFS.TXN:

    R.TFS.TXN<TFS.TXN.CR.TXN.CODE> = ''
    R.TFS.TXN<TFS.TXN.DR.TXN.CODE> = ''
    R.TFS.TXN<TFS.TXN.CR.ALLOWED.AC> = ''
    R.TFS.TXN<TFS.TXN.DR.ALLOWED.AC> = ''
    R.TFS.TXN<TFS.TXN.CR.ALLOWED.CCY> = ''
    R.TFS.TXN<TFS.TXN.DR.ALLOWED.CCY> = ''
    R.TFS.TXN<TFS.TXN.CR.CATEG> = ''
    R.TFS.TXN<TFS.TXN.DR.CATEG> = ''
    IF NOT(R.TFS.TXN<TFS.TXN.DC.TXN.CODE.CR>) THEN
        R.TFS.TXN<TFS.TXN.DC.TXN.CODE.CR> = TFS$R.TFS.PAR<TFS.PAR.DC.TXN.CODE.CR>
    END
    IF NOT(R.TFS.TXN<TFS.TXN.DC.TXN.CODE.DR>) THEN
        R.TFS.TXN<TFS.TXN.DC.TXN.CODE.DR> = TFS$R.TFS.PAR<TFS.PAR.DC.TXN.CODE.DR>
    END

RETURN
*------------------------------------------------------------------------------------
INIT.OPEN.FILES:

    PROCESS.GOAHEAD = 1
    R.TFS.TXN = ''

    FN.TXN = 'F.TRANSACTION' ; F.TXN = ''
    FN.FT.TXN = 'F.FT.TXN.TYPE.CONDITION' ; F.FT.TXN = ''
    FN.TT.TXN = 'F.TELLER.TRANSACTION' ; F.TT.TXN = ''
    FN.TFS.TXN = 'F.TFS.TRANSACTION' ; F.TFS.TXN = ''

RETURN
*-------------------------------------------------------------------------------------
END


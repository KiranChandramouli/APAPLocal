* @ValidationCode : MjotMTk5NzA0MTU2NzpDcDEyNTI6MTY5ODMxMzQwNjQ1NDozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Oct 2023 15:13:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TFS
*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE T24.FS.INTERFACE.FT(MV.NO,OFS.BODY)
*
* Subroutine to Create OFS Message for FT, based on the value from
* R.NEW.
*
* MV.NO - The Multi Value Number or the Line Number to be processed
*
*=======================================================================
*
* Modification History:
*
* 09/22/04   - Sathish PS
*              New Development
*
* 18 SEP 07 - Sathish PS
*             Allow Account currency to be different from Transaction Currency
*
* 08/05/09  -  Anitha.S
*              included Anti Money Laundering Gap for Multi Line Teller
*
* 18/06/09  -  Anitha .S
*              multiline TFS not checking for stop payment HD0920984
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Suresh             R22 Manual Conversion            USPLATFORM.BP File Removed, CALL routine format modified
*=======================================================================
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INCLUDE I_T24.FS.COMMON

    $INSERT I_F.FUNDS.TRANSFER
    $INCLUDE I_F.T24.FUND.SERVICES ;*R22 Manual Conversion
    $INCLUDE I_F.TFS.PARAMETER ;*R22 Manual Conversion
    $INCLUDE I_F.TFS.TRANSACTION ;*R22 Manual Conversion
    
    $USING APAP.TFS

    GOSUB INIT
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN
*========================================================================
PROCESS:
    ! 18 SEP 07 - Sathish PS /s
    CR.AC = R.NEW(TFS.ACCOUNT.CR)<1,MV.NO>
    CALL F.READ(FN.AC,CR.AC,R.CR.AC,F.AC,ERR.AC)
    CR.AC.CCY = R.CR.AC<AC.CURRENCY>
    IF NOT(CR.AC.CCY) THEN
        IF NOT(NUM(CR.AC)) THEN
            CR.AC.CCY = CR.AC[1,3]
        END
    END

    DR.AC = R.NEW(TFS.ACCOUNT.DR)<1,MV.NO>
    CALL F.READ(FN.AC,DR.AC,R.DR.AC,F.AC,ERR.AC)
    DR.AC.CCY = R.DR.AC<AC.CURRENCY>
    IF NOT(DR.AC.CCY) THEN
        IF NOT(NUM(DR.AC)) THEN
            DR.AC.CCY = DR.AC[1,3]
        END
    END
    ! 18 SEP 07 - Sathish PS /e

    OFS.BODY = 'TRANSACTION.TYPE:1:1=' : TFS$R.TFS.TXN(MV.NO)<TFS.TXN.INTERFACE.AS> :','
    OFS.BODY := 'DEBIT.ACCT.NO:1:1=' : R.NEW(TFS.ACCOUNT.DR)<1,MV.NO> :','
    ! 18 SEP 07 - Sathish PS /s
    !    OFS.BODY := 'DEBIT.CURRENCY:1:1=' : R.NEW(TFS.CURRENCY)<1,MV.NO> :','
    OFS.BODY := 'DEBIT.CURRENCY:1:1=' : DR.AC.CCY :','
    ! 18 SEP 07 - Sathish PS /e
    OFS.BODY := 'DEBIT.AMOUNT:1:1=' : R.NEW(TFS.AMOUNT)<1,MV.NO> :','
    OFS.BODY := 'DEBIT.VALUE.DATE:1:1=' : R.NEW(TFS.DR.VALUE.DATE)<1,MV.NO> :','
    OFS.BODY := 'DEBIT.THEIR.REF:1:1=' : ID.NEW :','
    OFS.BODY := 'CREDIT.THEIR.REF:1:1=' : ID.NEW :','
    OFS.BODY := 'CREDIT.ACCT.NO:1:1=' : R.NEW(TFS.ACCOUNT.CR)<1,MV.NO> :','
    ! 18 SEP 07 - Sathish PS /s
    !    OFS.BODY := 'CREDIT.CURRENCY:1:1=' : R.NEW(TFS.CURRENCY)<1,MV.NO> :','
    OFS.BODY := 'CREDIT.CURRENCY:1:1=' : CR.AC.CCY :','
    ! 18 SEP 07 - Sathish PS /e
    OFS.BODY := 'CREDIT.VALUE.DATE:1:1=' : R.NEW(TFS.CR.VALUE.DATE)<1,MV.NO> :','

    AC.ID = R.NEW(TFS.ACCOUNT.CR)<1,MV.NO> ; GOSUB CHECK.ACC.TYPE
    IF CUS.AC THEN
        OFS.BODY := 'EXPOSURE.DATE:1:1=' : R.NEW(TFS.CR.EXP.DATE)<1,MV.NO> :','
    END
*18/06/09 S Anitha multiline TFS not checking for stop payment HD0920984
*IF R.NEW(TFS.CHQ.TYPE)<1,MV.NO> AND R.NEW(TFS.CHEQUE.NUMBER)<1,MV.NO>  THEN
    IF R.NEW(TFS.CHQ.TYPE)<1,MV.NO> OR R.NEW(TFS.CHEQUE.NUMBER)<1,MV.NO>  THEN
*18/06/09 E Anitha multiline TFS not checking for stop payment HD0920984

        OFS.BODY := 'CHEQ.TYPE:1:1=' : R.NEW(TFS.CHQ.TYPE)<1,MV.NO> :','
        OFS.BODY := 'CHEQUE.NUMBER:1:1=' : R.NEW(TFS.CHEQUE.NUMBER)<1,MV.NO> :','
    END

    IF R.NEW(TFS.CHG.CODE)<1,MV.NO> EQ '' THEN
        OFS.BODY := 'CHARGE.CODE:1:1=WAIVE,'
        OFS.BODY := 'COMMISSION.CODE:1:1=WAIVE,'
    END ELSE
        GOSUB DETERMINE.CHARGE.COMM
        OFS.BODY := CHG.COMM:'.CODE:1:1=': CHG.COMM.CODE :','
        OFS.BODY := CHG.COMM:'.TYPE:1:1=' : R.NEW(TFS.CHG.CODE)<1,MV.NO> :','
        IF R.NEW(TFS.CHG.AMT)<1,MV.NO> THEN
            CHG.CCY = R.NEW(TFS.CHG.CCY)<1,MV.NO>
            IF NOT(CHG.CCY) THEN CHG.CCY = R.NEW(TFS.CURRENCY)<1,MV.NO>
            OFS.BODY := CHG.COMM:'.AMT:1:1=' : CHG.CCY : R.NEW(TFS.CHG.AMT)<1,MV.NO> :','
        END
    END

    IF NOT(DR.CUS.AC) THEN
        OFS.BODY := 'ORDERING.CUST:1:1=ANY,'
    END

    IF R.NEW(TFS.STANDING.ORDER)<1,MV.NO> THEN
        OFS.BODY := 'TFS.STO.ID:1:1=' : R.NEW(TFS.STANDING.ORDER)<1,MV.NO> :','
    END

    OFS.BODY := 'T24.FS.REF:1:1=' : ID.NEW :','

*S Anitha 08/05/09 Anti Money Laundering Gap for Multi Line Teller
*    CALL GET.LOC.REF.UPDATE(OFS.BDY)
    APAP.TFS.getLocRefUpdate(OFS.BDY) ;*R22 Manual Conversion
    
    OFS.BODY:= OFS.BDY
*E Anitha 08/05/09 Anti Money Laundering Gap for Multi Line Teller

RETURN
*========================================================================
CHECK.ACC.TYPE:

    CALL F.READ(FN.AC,AC.ID,R.AC,F.AC,ERR.AC)
    CUS.AC = R.AC<AC.CUSTOMER> NE ''

RETURN
*=======================================================================
DETERMINE.CHARGE.COMM:

    CHG.COMM.TYPE = R.NEW(TFS.CHG.CODE)<1,MV.NO>
    CALL F.READ(FN.CHG.TYPE,CHG.COMM.TYPE,R.CHG.TYPE,F.CHG.TYPE,ERR.CHG.TYPE)
    IF R.CHG.TYPE THEN
        CHG.COMM = 'CHARGE'
    END ELSE
        CALL F.READ(FN.COMM.TYPE,CHG.COMM.TYPE,R.COMM.TYPE,F.COMM.TYPE,ERR.COMM.TYPE)
        IF R.COMM.TYPE THEN
            CHG.COMM = 'COMMISSION'
        END
    END
*
    CR.CUS.AC = '' ; DR.CUS.AC = ''
    CHG.COMM.CODE = ''
    AC.ID = R.NEW(TFS.ACCOUNT.CR)<1,MV.NO>
    GOSUB CHECK.ACC.TYPE
    CR.CUS.AC = CUS.AC
    AC.ID = R.NEW(TFS.ACCOUNT.DR)<1,MV.NO>
    GOSUB CHECK.ACC.TYPE
    DR.CUS.AC = CUS.AC

    BEGIN CASE
        CASE CR.CUS.AC AND NOT(DR.CUS.AC)
            CHG.COMM.CODE = 'CREDIT LESS CHARGES'

        CASE DR.CUS.AC AND NOT(CR.CUS.AC)
            CHG.COMM.CODE = 'DEBIT PLUS CHARGES'

        CASE OTHERWISE
            CHG.COMM.CODE = ''
    END CASE

RETURN
*----------------------------------------------------------------------
INIT:

    PROCESS.GOAHEAD = 1
    OFS.BODY = ''
    CR.CUS.AC = '' ; DR.CUS.AC = ''

    FN.AC = 'F.ACCOUNT' ; F.AC = ''
    FN.CHG.TYPE = 'F.FT.CHARGE.TYPE' ; F.CHG.TYPE = ''
    FN.COMM.TYPE = 'F.FT.COMMISSION.TYPE' ; F.COMM.TYPE = ''
    IF R.NEW(TFS.REVERSAL.MARK)<1,MV.NO> NE '' THEN PROCESS.GOAHEAD = 0

RETURN
*========================================================================
END


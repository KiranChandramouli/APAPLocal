* @ValidationCode : MjotMTg4MDk4NTA1NTpDcDEyNTI6MTY5Mzg5MzUzOTEyMzozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Sep 2023 11:28:59
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
$PACKAGE APAP.ATM
*-----------------------------------------------------------------------------
* <Rating>61</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE AT.ISO.CALC.CR.ACCT(ATM.ID,CREDIT.ACCT.NO)
*
*Modification History
*  Date       Who             Reference       Description
* 24 Aug 2011 Balagurunathan ODR-2010-08-0469 added the logic to handle term ids with less length
*05/09/2023      Conversion tool            R22 Auto Conversion             Nochange
*05/09/2023      Suresh                     R22 Manual Conversion           Nochange
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATM.BRANCH
    $INSERT I_F.ATM.PARAMETER
    $INSERT I_F.ATM.BIN.ACCT
    $INSERT I_F.NUMERIC.CURRENCY
    $INSERT I_AT.ISO.COMMON
*/ISO 8583 ATM interface to find the atm cash account (credit) when atm id
*is passed


    DBT.ACCT=AT$INCOMING.ISO.REQ(102)

    GOSUB OPEN.FILES
    DEFAULT.BIN = '123123'
    IF BIN.NO EQ '1' OR BIN.NO[1,6] EQ OUR.BIN THEN
        GOSUB OUR.BNK.PROCESS
    END ELSE
        GOSUB OTH.BNK.PROCESS
    END
RETURN

OPEN.FILES:
*-----------*
    FN.ATM.PARAMETER = 'F.ATM.PARAMETER'
    CALL OPF(FN.ATM.PARAMETER,F.ATM.PARAMETER)
*
    CALL CACHE.READ(FN.ATM.PARAMETER,'SYSTEM',R.ATM.PARAMETER,ER.ATM.PARAMETER)
*
    OUR.BIN = R.ATM.PARAMETER<ATM.PARA.BANK.IMD>
*    BIN.NO = ATM.ID[1,6]
    BIN.NO = FIELD(ATM.ID,'%',1)
    BIN.NO=BIN.NO*1
*
    FN.ATM.BRANCH = 'F.ATM.BRANCH'
    CALL OPF(FN.ATM.BRANCH,F.ATM.BRANCH)

    FN.ATM.BIN.ACCT = 'F.ATM.BIN.ACCT'
    CALL OPF(FN.ATM.BIN.ACCT,F.ATM.BIN.ACCT)

    FN.NUMERIC.CURRENCY='F.NUMERIC.CURRENCY'
    CALL OPF(FN.NUMERIC.CURRENCY,F.NUMERIC.CURRENCY)
    CCY=FIELD(ATM.ID,'%',3)
    CALL F.READ(FN.NUMERIC.CURRENCY,CCY,R.NUMERIC.CURRENCY,F.NUMERIC.CURRENCY,ER.NUM.CCY)
    CCY.NO=R.NUMERIC.CURRENCY<EB.NCN.CURRENCY.CODE>
*
RETURN  ;*Open files


*--------------------------------------------------------------------------*

OUR.BNK.PROCESS:
*----------*
*    commented by liril



*PACS00087222 trimed the ATM branch ID

    ATM.BR=FIELD(ATM.ID,'%',2)

    ATM.BR=TRIM(ATM.BR)
*Modified for PACS00054730-------------------------------------------------------
    CALL F.READ(FN.ATM.BRANCH,ATM.BR,R.ATM.BRANCH,F.ATM.BRANCH,ER.ATM.BRANCH)
*End of Modification-------------------------------------------------------------
    IF ER.ATM.BRANCH THEN

        CALL F.READ(FN.ATM.BRANCH,'HBDF01',R.ATM.BRANCH,F.ATM.BRANCH,ER.ATM.BRANCH)
        IF ER.ATM.BRANCH THEN
            PRINT ('ATM.ISO.BRANCH not set up default acct not found!')
        END ELSE
            AC.SUFFX = R.ATM.BRANCH<ATM.BR.UTIL.AC.SUFX,1>
            CR.ACCT.CATEG = R.ATM.BRANCH<ATM.BR.DEV.ID.INT.ACCT,1>
            IF AC.SUFFX THEN
                CREDIT.ACCT.NO = CCY.NO:AC.SUFFX:CR.ACCT.CATEG
            END ELSE
                CREDIT.ACCT.NO =CR.ACCT.CATEG
            END
        END

    END
    IF R.ATM.BRANCH THEN
        LEN.ATM.ID = LEN(ATM.ID)
*        NEW.LEN.ATM.ID = LEN.ATM.ID -6
*        NEW.LEN.ATM.ID = LEN.ATM.ID -12
        NUMERIC.ID.ATM = TRIM(ATM.BR[7,2])
        NUMERIC.ID.ATM=FMT(NUMERIC.ID.ATM,"R%2")
        FIND NUMERIC.ID.ATM IN R.ATM.BRANCH<ATM.BR.DEVICE.ID> SETTING ATM.FOUND.POSN1,ATM.FOUND.POSN ELSE ATM.FOUND.POSN = ''
        IF ATM.FOUND.POSN THEN
            AC.SUFFX = R.ATM.BRANCH<ATM.BR.DEV.ID.AC.SUFX,ATM.FOUND.POSN>
            CR.ACCT.CATEG = R.ATM.BRANCH<ATM.BR.DEV.ID.CATEG,ATM.FOUND.POSN>
            IF AC.SUFFX THEN
                CREDIT.ACCT.NO = CCY.NO:CR.ACCT.CATEG:AC.SUFFX
            END ELSE
                CR.ACCT.CATEG=R.ATM.BRANCH<ATM.BR.DEV.ID.INT.ACCT,ATM.FOUND.POSN>
                CREDIT.ACCT.NO =CR.ACCT.CATEG
            END

        END
    END



RETURN  ;*From OUR.BNK.process

*---------------------------------------------------------------------------*
OTH.BNK.PROCESS:
*--------------*

    CALL F.READ(FN.ATM.BIN.ACCT,ATM.BR,R.ATM.BIN.ACCT,F.ATM.BIN.ACCT,ER.ATM.BIN.ACCT)

*/added by liril for booking all in one acct
    IF NOT(R.ATM.BIN.ACCT) THEN
        CALL F.READ(FN.ATM.BIN.ACCT,DEFAULT.BIN,R.ATM.BIN.ACCT,F.ATM.BIN.ACCT,ER.ATM.BIN.ACCT)
    END
*/end of liril change

    CREDIT.ACCT.NO = R.ATM.BIN.ACCT<BIN.PAY.ACCOUNT.NO>

RETURN  ;*From oth.bnk.process

*---------------------------------------------------------------------------*

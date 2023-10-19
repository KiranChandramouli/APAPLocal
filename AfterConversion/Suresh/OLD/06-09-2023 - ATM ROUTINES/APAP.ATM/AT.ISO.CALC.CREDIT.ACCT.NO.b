* @ValidationCode : MjotMjA5OTIwMTE4NjpDcDEyNTI6MTY5Mzg5MzU3NzIzMDozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Sep 2023 11:29:37
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
SUBROUTINE AT.ISO.CALC.CREDIT.ACCT.NO(INCOMING,CREDIT.ACCT.NO)
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*05/09/2023      Conversion tool            R22 Auto Conversion             Nochange
*05/09/2023      Suresh                     R22 Manual Conversion           Nochange
*-------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATM.BRANCH
    $INSERT I_F.ATM.BIN.ACCT
    $INSERT I_F.ATM.PARAMETER
*



    Y.CARD.BIN.NO = INCOMING[1,6]
    Y.ISSU.BIN.NO = INCOMING[7,6]
    Y.ATM.ID = INCOMING[13,8]
*Modified for PACS00054730------------------------------------------------------
    Y.BRANCH.ID = Y.ATM.ID
*End of Modification---------------------------------------------------------
    Y.BRANCH.ID=TRIM(Y.BRANCH.ID,"0","L")
    Y.BR.ATM.NO = Y.ATM.ID[5,4]

    Y.CCY=INCOMING[21,3]

    DEFAULT.BIN = '123123'

    GOSUB OPEN.FILES

    IF Y.ISSU.BIN.NO EQ OUR.BIN THEN
        GOSUB OUR.PROCESS
    END ELSE
        GOSUB OTH.PROCESS
    END

RETURN

*-------------------------------------------------------------------------------
OPEN.FILES:
*
    FN.ATM.PARAMETER = 'F.ATM.PARAMETER'
    CALL OPF(FN.ATM.PARAMETER,F.ATM.PARAMETER)

*  CALL F.READ(FN.ATM.PARAMETER,'SYSTEM',R.ATM.PARAMETER,F.ATM.PARAMETER,ER.ATM.PARAMETER) ;*Tus Start
    CALL CACHE.READ(FN.ATM.PARAMETER,'SYSTEM',R.ATM.PARAMETER,ER.ATM.PARAMETER) ; * Tus End
    OUR.BIN = R.ATM.PARAMETER<ATM.PARA.BANK.IMD>

    FN.ATM.ISO.BRANCH = 'F.ATM.BRANCH'
    F.ATM.ISO.BRANCH = ''
    CALL OPF(FN.ATM.ISO.BRANCH,F.ATM.ISO.BRANCH)

    FN.ATM.BIN.ACCT = 'F.ATM.BIN.ACCT'
    F.ATM.BIN.ACCT = ''
    CALL OPF(FN.ATM.BIN.ACCT,F.ATM.BIN.ACCT)

RETURN  ;* open files

*-------------------------------------------------------------------------------
OUR.PROCESS:
*
    CALL F.READ(FN.ATM.ISO.BRANCH,Y.BRANCH.ID,R.ATM.BRANCH,F.ATM.ISO.BRANCH,ER.ATM.BRANCH)
    IF ER.ATM.BRANCH THEN
        PRINT ('ATM.BRANCH not set up')
    END
    IF R.ATM.BRANCH THEN
        FIND Y.BR.ATM.NO IN R.ATM.BRANCH<ATM.BR.DEVICE.ID> SETTING ATM.FOUND.POSN1,ATM.FOUND.POSN ELSE ATM.FOUND.POSN = ''
        IF ATM.FOUND.POSN THEN
            AC.SUFFX = R.ATM.BRANCH<ATM.BR.DEV.ID.AC.SUFX,ATM.FOUND.POSN>
            CR.ACCT.CATEG = R.ATM.BRANCH<ATM.BR.DEV.ID.CATEG,ATM.FOUND.POSN>
            IF AC.SUFFX THEN
                CREDIT.ACCT.NO = Y.CCY:CR.ACCT.CATEG:AC.SUFFX
            END ELSE
                CREDIT.ACCT.NO =R.ATM.BRANCH<ATM.BR.DEV.ID.INT.ACCT>
            END
        END
    END
RETURN  ;* from OUR.PROCESS

*-------------------------------------------------------------------------------
OTH.PROCESS:
*
    CALL F.READ(FN.ATM.BIN.ACCT,Y.ISSU.BIN.NO,R.ATM.BIN.ACCT,F.ATM.BIN.ACCT,ER.ATM.BIN.ACCT)

* for booking all in one acct
    IF NOT(R.ATM.BIN.ACCT) THEN
        CALL F.READ(FN.ATM.BIN.ACCT,DEFAULT.BIN,R.ATM.BIN.ACCT,F.ATM.BIN.ACCT,ER.ATM.BIN.ACCT)
    END
* end of booking all in one acct

    CREDIT.ACCT.NO = R.ATM.BIN.ACCT<BIN.PAY.ACCOUNT.NO>

RETURN  ;* from OTH.PROCESS

*-------------------------------------------------------------------------------

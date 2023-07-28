* @ValidationCode : MjotMTQ4NjIzMDA4NTpDcDEyNTI6MTY4MTI4Mzk0MjI5NTpJVFNTOi0xOi0xOjM2MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:49:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 360
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*11-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*--------------------------------------------------------------------------------------------------------------------------
SUBROUTINE REDO.AZ.PENAL.AMT.CALC(PENAL.PER,PR.DEP.DAYS,PEN.AMT)
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.AZ.PENAL.AMT.CALC
*--------------------------------------------------------------------------------------------------------
*Description       : This routine iS called inside the validation routine
*                    REDO.AZ.AC.PREC.VAL.ROLL.OVER and REDO.AZ.AC.PREC.VAL.PENAL.PCNT
*                    which are attached to AZ.ACCOUNT,FD.PRECLOSE.It is used to calculate the peanlty amount
*In Parameter      : PENAL.PER , PR.DEP.DAYS
*Out Parameter     : PEN.AMT
*Files  Used       : AZ.ACCOUNT               As             I/O          Mode
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*  Date              Who                 Reference                  Description
*  ------            ------              -------------              -------------
*  22/06/2010        REKHA S             ODR-2009-10-0336 N.18      Initial Creation
*  11 MAR 2011       H GANESH            PACS00032973  - N.18       Modified as per issue
*  05 MAR 2019       GOPALA KRISHNAN R    PACS00736522               ISSUE FIX
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_F.TELLER
    $INSERT I_F.INTEREST.BASIS

    GOSUB INIT

    GOSUB MAIN.PROCESS
RETURN
*--------------------------------------------------------------------------------------------------------
INIT:
*****
    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    R.AZ.ACCOUNT = ''
    Y.AZ.ACCT.ERR = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.AZ.PRODUCT.PARAMETER = 'F.AZ.PRODUCT.PARAMETER'
    F.AZ.PRODUCT.PARAMETER = ''

    CALL OPF(FN.AZ.PRODUCT.PARAMETER,F.AZ.PRODUCT.PARAMETER)


RETURN
*--------------------------------------------------------------------------------------------------------
MAIN.PROCESS:
*************


    IF ID.NEW[1,2] EQ 'TT' THEN
        GOSUB TT.PROCESS
    END ELSE
        GOSUB AZ.PROCESS
    END

RETURN
*-------------------------------------------------------------------------------------------------------
AZ.PROCESS:
***********

* PACS00736522 - S
    PRINCIPAL.OLD = ""
    PRINCIPAL.OLD = R.NEW.LAST(AZ.ORIG.PRINCIPAL)
    IF PRINCIPAL.OLD THEN
        PRINCIPAL.AMT = R.NEW.LAST(AZ.ORIG.PRINCIPAL)
    END ELSE
        PRINCIPAL.AMT = R.NEW(AZ.PRINCIPAL)
    END
* PACS00736522 - E
    INT.RATE = R.NEW(AZ.INTEREST.RATE)/100
    PENAL.PER = PENAL.PER/100
*DISCOUNT.RATE = INT.RATE - ( PENAL.PER * INT.RATE)
    DISCOUNT.RATE=PENAL.PER * INT.RATE
    Y.CATEGORY = R.NEW(AZ.ALL.IN.ONE.PRODUCT)

    GOSUB GET.INT.BASIS
    PEN.AMT = (DISCOUNT.RATE * PRINCIPAL.AMT * PR.DEP.DAYS)/(Y.NUM.BAS)
    PEN.AMT=TRIM(FMT(PEN.AMT,'L2#19'),' ','B')

RETURN
*--------------------------------------------------------------------------------------------------------
GET.INT.BASIS:
**************
    CALL F.READ(FN.AZ.PRODUCT.PARAMETER,Y.CATEGORY,R.AZ.PRODUCT.PARAMETER,F.AZ.PRODUCT.PARAMETER,Y.AZ.ERR)
    IF R.AZ.PRODUCT.PARAMETER AND Y.AZ.ERR EQ '' THEN
        INT.DAY.BASIS = R.AZ.PRODUCT.PARAMETER<AZ.APP.INT.BASIS>
        INT.DAY.BASIS = INT.DAY.BASIS[3,9]
        Y.NUM.BAS = FIELD(INT.DAY.BASIS,'/',1,1)
    END
RETURN
*---------------------------------------------------------------------------------------------------------
TT.PROCESS:
***********
    Y.TT.ACCT.NO = R.NEW(TT.TE.ACCOUNT.2)

    CALL F.READ(FN.AZ.ACCOUNT,Y.TT.ACCT.NO,R.AZ.ACCOUNT,F.AZ.ACCOUNT,Y.AZ.ACCT.ERR)
    INT.RATE = R.AZ.ACCOUNT<AZ.INTEREST.RATE>/100
    PENAL.PER=PENAL.PER / 100
*DISCOUNT.RATE = INT.RATE - ( PENAL.PER * INT.RATE)
    DISCOUNT.RATE = PENAL.PER * INT.RATE
    Y.CATEGORY = R.AZ.ACCOUNT<AZ.ALL.IN.ONE.PRODUCT>

    GOSUB GET.INT.BASIS

    Y.AZ.PRINCIPAL = R.AZ.ACCOUNT<AZ.PRINCIPAL>
    PEN.AMT  = (DISCOUNT.RATE * Y.AZ.PRINCIPAL * PR.DEP.DAYS) / Y.NUM.BAS
    Y.1.PART = FIELD(PEN.AMT,'.',1,1)
    Y.DEC.PART = FIELD(PEN.AMT,'.',2,1)

    IF LEN(Y.DEC.PART) GT '2' THEN
        Y.DEC.PART = Y.DEC.PART[1,2]
    END ELSE
        Y.DEC.PART = FMT(Y.DEC.PART,'R%2')
    END

    PEN.AMT = Y.1.PART:'.':Y.DEC.PART
RETURN
*------------------------------------------------------------------------------------------------------------
END

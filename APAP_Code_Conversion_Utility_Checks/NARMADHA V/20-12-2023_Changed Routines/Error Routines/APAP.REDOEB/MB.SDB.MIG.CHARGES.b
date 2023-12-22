* @ValidationCode : MjoxNzgyNzQzNzUzOkNwMTI1MjoxNjgxMzg0NDM1NTUwOklUU1M6LTE6LTE6ODAwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Apr 2023 16:43:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 800
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE MB.SDB.MIG.CHARGES(BOX.TYPE.NO,STO.REF)
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 12-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 12-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.MB.SDB.TYPE
    $INSERT I_F.MB.SDB.CHARGES
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT


    FN.SDB.TYPE = 'F.MB.SDB.TYPE' ; F.SDB.TYPE = ''
    CALL OPF(FN.SDB.TYPE,F.SDB.TYPE)

    FN.SDB.CHARGES = 'F.MB.SDB.CHARGES' ; F.SDB.CHARGES = ''
    CALL OPF(FN.SDB.CHARGES,F.SDB.CHARGES)

    FN.ACCOUNT = 'F.ACCOUNT'; FP.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT, FP.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'; FP.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER, FP.CUSTOMER)


    COMP.CODE = FIELD(BOX.TYPE.NO,'.',1)
    BOX.TYPE = FIELD(BOX.TYPE.NO,'.',2)
    BOX.NO = FIELD(BOX.TYPE.NO,'.',3)
    ACCT.NO = FIELD(STO.REF,'.',1)

    AC.REC = ''; AC.ERR = ''
    CALL F.READ(FN.ACCOUNT, ACCT.NO, ACC.REC, FP.ACCOUNT, AC.ERR)

    CUST.NO = AC.REC<AC.CUSTOMER>; CUST.REC = ''; CUST.ERR = ''
    CALL F.READ(FN.CUSTOMER, CUST.NO, CUST.REC, FP.CUSTOMER, CUST.ERR)
    CUST.INDUSTRY = CUST.REC<EB.CUS.INDUSTRY>

    IF BOX.TYPE THEN

        CALL F.READ(FN.SDB.TYPE,BOX.TYPE,R.BOX.TYPE,F.BOX.TYPE,BOX.ERR)

        IF NOT(BOX.ERR) THEN
            RENT.DISC = 0
            BOX.RENT = R.BOX.TYPE<SDB.TYP.PERIODIC.RENT,1>
            VAT.AMT = R.BOX.TYPE<SDB.TYP.VAT.ON.RENT,1>
            STAFF.DISC = 0.2
            DEPOSIT.AMT = 50

            IF CUST.INDUSTRY EQ '1040' THEN
                RENT.DISC  = BOX.RENT * STAFF.DISC
                VAT.AMT = RENT.DISC *.175
                DEPOSIT.AMT = 0
            END
            TOT.CHARGES = DEPOSIT.AMT + BOX.RENT + VAT.AMT - RENT.DISC
            R.MB.SDB.STATUS<SDB.CHG.PERIODIC.RENT> = BOX.RENT
            R.MB.SDB.CHARGES<SDB.CHG.DISCOUNT.AMT> = RENT.DISC
            R.MB.SDB.CHARGES<SDB.CHG.VAT.AMOUNT> = VAT.AMT
            R.MB.SDB.CHARGES<SDB.CHG.DEPOSIT.AMT> = DEPOSIT.AMT
            R.MB.SDB.CHARGES<SDB.CHG.TOTAL.CHARGE.AMT> = TOT.CHARGES
            R.MB.SDB.CHARGES<SDB.CHG.PAY.REASON> = 'Migrated Box Information'

            WRITE R.MB.SDB.CHARGES TO F.SDB.CHARGES,BOX.TYPE.NO ON ERROR NULL

        END
    END

RETURN
END

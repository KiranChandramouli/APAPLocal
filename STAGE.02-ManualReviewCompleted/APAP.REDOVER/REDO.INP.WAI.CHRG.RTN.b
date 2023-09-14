* @ValidationCode : MjotMTk2MzExMzc4MjpDcDEyNTI6MTY4MDc3Mjg5MTMyODpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 14:51:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.INP.WAI.CHRG.RTN
*-----------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Shankar Raju
*Program Name      : REDO.INP.DSPL.OVRDS
*Date              : 15/02/2011
*-----------------------------------------------------------------------
*Description       : This is a T24 routine to display the override when WAIVE.CHARGE is set to YES
*Linked With       : FT,CHQ.TAX  , FT,CHQ.NO.TAX , FT,CHQ.OTHERS , FT,MGRUSD.CHQ.TAX , FT,MGRUSD.CHQ.NO.TAX
*Linked File       : N/A
*-----------------------------------------------------------------------
* Input/Output:
* -------------
* In  : N/A
* Out : N/A
*-----------------------------------------------------------------------
* Dependencies:
* -------------
* Calls     : N/A
* Called By : N/A
*-----------------------------------------------------------------------
*-----------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE              WHO           REFERENCE                            DESCRIPTION
*15-03-11     SUDHARSANAN S      PACS00023910                  Check the condition based on versions
*11-05-11       Bharath G         PACS00023918                  Read charge and tax from FTTC
*06-04-2023    Conversion Tool     R22 Auto Code conversion      VM TO @VM , ++ TO +=1,F.READ TO CACHE.READ
*06-04-2023     Samaran T          Manual R22 Code Conversion    No Changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.MANAGER.CHQ.PARAM
    $INSERT I_F.REDO.ADMIN.CHQ.PARAM
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.FT.TXN.TYPE.CONDITION

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------
INITIALISE:
*----------
    FN.REDO.MANAGER.CHQ.PARAM = 'F.REDO.MANAGER.CHQ.PARAM'
    F.REDO.MANAGER.CHQ.PARAM = ''
    R.REDO.MANAGER.CHQ.PARAM = ''
    CALL OPF(FN.REDO.MANAGER.CHQ.PARAM,F.REDO.MANAGER.CHQ.PARAM)

    FN.REDO.ADMIN.CHQ.PARAM = 'F.REDO.ADMIN.CHQ.PARAM'
    F.REDO.ADMIN.CHQ.PARAM = ''
    R.REDO.ADMIN.CHQ.PARAM = ''
    CALL OPF(FN.REDO.ADMIN.CHQ.PARAM,F.REDO.ADMIN.CHQ.PARAM)

    FN.FT.COMMISSION.TYPE = 'F.FT.COMMISSION.TYPE'
    F.FT.COMMISSION.TYPE = ''
    R.FT.COMMISSION.TYPE = ''
    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)

    FN.FT.TXN.TYPE.CONDITION = 'F.FT.TXN.TYPE.CONDITION'
    F.FT.TXN.TYPE.CONDITION = ''
    R.FT.TXN.TYPE.CONDITION = ''
    CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)

    ERR.PAR = ''

    LREF.APPLN = 'FUNDS.TRANSFER'
    LREF.FLDS = 'WAIVE.TAX':@VM:'L.TT.WAI.CHARGE':@VM:'L.FT.WAI.TAXAMT'
    LREF.POS = ''

    CALL MULTI.GET.LOC.REF(LREF.APPLN,LREF.FLDS,LREF.POS)
    POS.WAIVE.TAX = LREF.POS<1,1>
    POS.WAIVE.CHARGE = LREF.POS<1,2>
    POS.WAIVE.AMT = LREF.POS<1,3>
    COMM.CHARGE.CODE = ''
    TAX.CHARGE.CODE = ''
    CHG.COMM.AMT.SAVE = ''
    TOT.TAX.COMM.AMT = ''

    Y.CREDIT.AC = R.NEW(FT.CREDIT.ACCT.NO)

*PACS00023910 - S
    IF PGM.VERSION[2,3] EQ 'CHQ' THEN     ;* PACS00023918
        CALL CACHE.READ(FN.REDO.ADMIN.CHQ.PARAM,'SYSTEM',R.REDO.ADMIN.CHQ.PARAM,ERR.PAR)
        Y.ALL.AC.NOS = R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ACCOUNT>
        Y.ALL.TAX.KEY = R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.TAX.KEY>
    END
    ELSE
        CALL CACHE.READ(FN.REDO.MANAGER.CHQ.PARAM,'SYSTEM',R.REDO.MANAGER.CHQ.PARAM,ERR.PAR)
        Y.ALL.AC.NOS = R.REDO.MANAGER.CHQ.PARAM<MAN.CHQ.PRM.ACCOUNT>
        Y.ALL.TAX.KEY = R.REDO.MANAGER.CHQ.PARAM<MAN.CHQ.PRM.TAX.KEY>
    END
*PACS00023910 - E

    LOCATE Y.CREDIT.AC IN Y.ALL.AC.NOS<1,1> SETTING POS3 THEN
        Y.TAX.KEY = Y.ALL.TAX.KEY<1,POS3>
    END

* PACS00023918 - S

    Y.FTTC         = R.NEW(FT.TRANSACTION.TYPE)
    Y.DEBIT.AMOUNT = R.NEW(FT.DEBIT.AMOUNT)

    CALL CACHE.READ(FN.FT.TXN.TYPE.CONDITION, Y.FTTC, R.FT.TXN.TYPE.CONDITION, FTTC.ERR)  ;*R22 AUTO CODE CONVERSION
    IF R.FT.TXN.TYPE.CONDITION THEN
        Y.ALL.CHARGE.CODE = R.FT.TXN.TYPE.CONDITION<FT6.COMM.TYPES>
    END

    Y.NO.CHARGE.CODES = DCOUNT(Y.ALL.CHARGE.CODE,@VM)
    START.COUNT = 1
    LOOP
    WHILE START.COUNT LE Y.NO.CHARGE.CODES
        GOSUB GET.VALUES
        START.COUNT += 1
    REPEAT

    Y.WAIVE.TAX = R.NEW(FT.LOCAL.REF)<1,POS.WAIVE.TAX>
    Y.WAIVE.CHARGE = R.NEW(FT.LOCAL.REF)<1,POS.WAIVE.CHARGE>

RETURN
*-----------------------------------------------------------------------
GET.VALUES:
*----------
*Calculation of Tax & Charge is done based on the FT.COMMISSION.TYPE

    Y.BASE.AMOUNT=Y.DEBIT.AMOUNT

    Y.CHARGE.CODE = Y.ALL.CHARGE.CODE<1,START.COUNT>
    CALL CACHE.READ(FN.FT.COMMISSION.TYPE, Y.CHARGE.CODE, R.FT.COMMISSION.TYPE, ERR.FTCT)   ;*R22 AUTO CODE CONVERSION

    GOSUB CALC.TAX.COMMSN

RETURN
*-----------------------------------------------------------------------
CALC.TAX.COMMSN:
*---------------
*
    IF R.FT.COMMISSION.TYPE THEN
        IF Y.CHARGE.CODE EQ Y.TAX.KEY THEN
            IF R.FT.COMMISSION.TYPE<FT4.PERCENTAGE> NE '' THEN
                TAX.COMM.AMT = DROUND(((R.FT.COMMISSION.TYPE<FT4.PERCENTAGE>*Y.BASE.AMOUNT)/100),2)
                IF TAX.COMM.AMT GE 0 THEN
                    TAX.CHARGE.CODE<1,-1>  = Y.CHARGE.CODE
                    TOT.TAX.COMM.AMT<1,-1> = LCCY:' ':TAX.COMM.AMT
                END
            END
        END
        ELSE
            IF R.FT.COMMISSION.TYPE<FT4.FLAT.AMT> NE '' THEN
                CHG.COMM.AMT = R.FT.COMMISSION.TYPE<FT4.FLAT.AMT>
            END ELSE
                CHG.COMM.AMT = DROUND(((R.FT.COMMISSION.TYPE<FT4.PERCENTAGE>*Y.BASE.AMOUNT)/100),2)
            END
            CHG.COMM.AMT.SAVE<1,-1> = LCCY:' ':CHG.COMM.AMT
            COMM.CHARGE.CODE<1,-1>  = Y.CHARGE.CODE
        END
    END
RETURN
* PACS00023918 - E
*-----------------------------------------------------------------------
PROCESS:
*-------
* PACS00023918 - S


    IF PGM.VERSION EQ ",CHQ.OTHERS.DEPOSIT" OR PGM.VERSION EQ ',CHQ.GOVT.WITH.TAX' THEN
        RETURN
    END

    IF Y.WAIVE.CHARGE EQ "YES" AND Y.WAIVE.TAX EQ "YES" THEN
        R.NEW(FT.CHARGES.ACCT.NO) = ''
        R.NEW(FT.CHARGE.TYPE) = ''
        R.NEW(FT.CHARGE.AMT) = ''
        R.NEW(FT.COMMISSION.TYPE) = ''
        R.NEW(FT.COMMISSION.AMT)  = ''
        R.NEW(FT.COMMISSION.CODE) = "WAIVE"
        R.NEW(FT.CHARGE.CODE) = "WAIVE"
    END

    IF Y.WAIVE.CHARGE EQ 'YES' AND Y.WAIVE.TAX NE 'YES' THEN
        R.NEW(FT.COMMISSION.TYPE) = ''
        R.NEW(FT.COMMISSION.AMT)  = ''
        IF TAX.CHARGE.CODE NE '' AND TOT.TAX.COMM.AMT NE '' THEN
            R.NEW(FT.COMMISSION.TYPE) = TAX.CHARGE.CODE
            R.NEW(FT.COMMISSION.AMT)  = TOT.TAX.COMM.AMT
        END ELSE
            R.NEW(FT.COMMISSION.TYPE) = ''
            R.NEW(FT.COMMISSION.AMT)  = ''
        END
        R.NEW(FT.COMMISSION.CODE) = 'DEBIT PLUS CHARGES'
    END

    IF Y.WAIVE.CHARGE NE 'YES' AND Y.WAIVE.TAX EQ 'YES' THEN
        R.NEW(FT.COMMISSION.CODE) = 'DEBIT PLUS CHARGES'
        R.NEW(FT.COMMISSION.TYPE) = ''
        R.NEW(FT.COMMISSION.AMT)  = ''
        R.NEW(FT.COMMISSION.TYPE) = COMM.CHARGE.CODE
        R.NEW(FT.COMMISSION.AMT)  = CHG.COMM.AMT.SAVE
    END

    IF (Y.WAIVE.CHARGE EQ "NO" OR Y.WAIVE.CHARGE EQ '') AND Y.WAIVE.TAX EQ "NO" THEN
        R.NEW(FT.COMMISSION.CODE) = 'DEBIT PLUS CHARGES'
        R.NEW(FT.COMMISSION.TYPE) = ''
        R.NEW(FT.COMMISSION.AMT)  = ''
        IF TAX.CHARGE.CODE NE '' AND TOT.TAX.COMM.AMT NE '' THEN
            R.NEW(FT.COMMISSION.TYPE) = COMM.CHARGE.CODE:@VM:TAX.CHARGE.CODE
            R.NEW(FT.COMMISSION.AMT)  = CHG.COMM.AMT.SAVE:@VM:TOT.TAX.COMM.AMT
        END ELSE
            R.NEW(FT.COMMISSION.TYPE) = COMM.CHARGE.CODE
            R.NEW(FT.COMMISSION.AMT)  = CHG.COMM.AMT.SAVE
        END
    END

* PACS00023918 - E

RETURN
*-----------------------------------------------------------------------
END

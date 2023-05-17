SUBROUTINE REDO.B.REP.RATES.AND.FEES(Y.TXN.ID)
*---------------------------------------------------------------------------------------------
*
* Description           : Batch routine to report information about files

* Developed By          : Thilak Kumar K
*
* Development Reference : TC01
*
* Attached To           : Batch - BNK/REDO.B.REP.RATES.AND.FEES
*
* Attached As           : Online Batch Routine to COB
*---------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : Y.TXN.ID -@ID FT,TT,FX application
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#4 : NA
*
*---------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*---------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* NA                     Thenmalar T                      19-Feb-2014           Modified as per clarificaiton received
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.FOREX
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.FT.CHARGE.TYPE
    $INSERT I_REDO.B.REP.RATES.AND.FEES.COMMON
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_F.COMPANY
*

    GOSUB PROCESS
*
RETURN
*---------------------------------------------------------------------------------------------
PROCESS:
*-------
*
    C$SPARE(451) = ''
    C$SPARE(452) = ''
    C$SPARE(453) = ''
    C$SPARE(454) = ''
    C$SPARE(455) = ''
    C$SPARE(456) = ''
    C$SPARE(457) = ''
    C$SPARE(458) = ''
    C$SPARE(459) = ''
    C$SPARE(460) = ''
    C$SPARE(461) = ''

    Y.LANG.CODE = R.COMPANY(EB.COM.LANGUAGE.CODE)

    Y.ID = FIELD(Y.TXN.ID,';',1,1)

    BEGIN CASE
        CASE Y.ID[1,2] EQ 'FT'
            GOSUB FT.TRANSACTION
        CASE Y.ID[1,2] EQ 'TT'
            GOSUB TT.TRANSACTION
        CASE Y.ID[1,2] EQ 'FX'
            GOSUB FX.TRANSACTION
    END CASE
*
RETURN
*---------------------------------------------------------------------------------------------
FT.TRANSACTION:
*--------------
*

    CALL F.READ(FN.FUNDS.TRANSFER,Y.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,Y.FT.ERR)
*
    IF R.FUNDS.TRANSFER EQ '' THEN
*        CALL F.READ(FN.FUNDS.TRANSFER.HIS,Y.TXN.ID,R.FUNDS.TRANSFER.HIS,F.FUNDS.TRANSFER.HIS,Y.FT.HIS.ERR)
        CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HIS,Y.TXN.ID,R.FUNDS.TRANSFER.HIS,Y.FT.HIS.ERR)
*
*20140410(S) - Removed core fields commission type & charge type and add local feilds as per the changes received
        Y.COMMISSION.TYPE = R.FUNDS.TRANSFER.HIS<FT.LOCAL.REF,Y.FT.COMM.CODE.POS>
*20140410(E)

        Y.FT.PAY.METHOD   = R.FUNDS.TRANSFER.HIS<FT.LOCAL.REF,L.FT.METHOD.POS>
        Y.CURRENCY1       = R.FUNDS.TRANSFER.HIS<FT.DEBIT.CURRENCY>
        Y.CURRENCY2       = R.FUNDS.TRANSFER.HIS<FT.CREDIT.CURRENCY>
    END ELSE

*20140410(S)
        Y.COMMISSION.TYPE = R.FUNDS.TRANSFER<FT.LOCAL.REF,Y.FT.COMM.CODE.POS>
*20140410(E)

        Y.FT.PAY.METHOD   = R.FUNDS.TRANSFER<FT.LOCAL.REF,L.FT.METHOD.POS>
        Y.CURRENCY1       = R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY>
        Y.CURRENCY2       = R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY>
    END
*
*20140111(S) - Removed the mandatory check of FT.PAY.METHOD as per the change request

*20140410(S) - Removed concenating of charge type
    Y.CHARGE.CODE = Y.COMMISSION.TYPE
*20140410(E)

    Y.METHOD = Y.FT.PAY.METHOD
    GOSUB GET.CHRG.DETAILS
*20140111(E)

*
RETURN
*---------------------------------------------------------------------------------------------
TT.TRANSACTION:
*--------------
*
    CALL F.READ(FN.TELLER,Y.ID,R.TELLER,F.TELLER,Y.TT.ERR)
*
    IF R.TELLER EQ '' THEN
*        CALL F.READ(FN.TELLER.HIS,Y.TXN.ID,R.TELLER.HIS,F.TELLER.HIS,Y.TT.HIS.ERR)
        CALL EB.READ.HISTORY.REC(F.TELLER.HIS,Y.TXN.ID,R.TELLER.HIS,Y.TT.HIS.ERR)

*20140410(S) - Removed core field charge code and add local feilds as per the changes received
        Y.CHARGE.CODE = R.TELLER.HIS<TT.TE.LOCAL.REF,Y.TT.COMM.CODE.POS>
*20140410(E)

        Y.TT.PAY.METHOD   = R.TELLER.HIS<TT.TE.LOCAL.REF,L.TT.METHOD.POS>
        Y.CURRENCY1       = R.TELLER.HIS<TT.TE.CURRENCY.1>
        Y.CURRENCY2       = R.TELLER.HIS<TT.TE.CURRENCY.2>
    END ELSE

*20140410(S) - Removed core field charge code and add local feilds as per the changes received
        Y.CHARGE.CODE = R.TELLER<TT.TE.LOCAL.REF,Y.TT.COMM.CODE.POS>
*20140410(E)

        Y.TT.PAY.METHOD   = R.TELLER<TT.TE.LOCAL.REF,L.TT.METHOD.POS>
        Y.CURRENCY1       = R.TELLER<TT.TE.CURRENCY.1>
        Y.CURRENCY2       = R.TELLER<TT.TE.CURRENCY.2>
    END
*
*20140111(S) - Removed the mandatory check of FT.PAY.METHOD as per the change request

    Y.METHOD = Y.TT.PAY.METHOD
    GOSUB GET.CHRG.DETAILS
*20140111(E)

*
RETURN
*---------------------------------------------------------------------------------------------
FX.TRANSACTION:
*--------------
*
    CALL F.READ(FN.FOREX,Y.ID,R.FOREX,F.FOREX,Y.FX.ERR)
*
    IF R.FOREX EQ '' THEN
*        CALL F.READ(FN.FOREX.HIS,Y.TXN.ID,R.FOREX.HIS,F.FOREX.HIS,Y.FX.HIS.ERR)
        CALL EB.READ.HISTORY.REC(F.FOREX.HIS,Y.TXN.ID,R.FOREX.HIS,Y.FX.HIS.ERR)
        Y.CHARGE.CODE    = R.FOREX.HIS<FX.CHARGE.CODE>
        Y.FX.PAY.METHOD  = R.FOREX.HIS<FX.LOCAL.REF,L.FX.METHOD.POS>
        Y.CURRENCY1      = R.FOREX.HIS<FX.CURRENCY.SOLD>
        Y.CURRENCY2      = R.FOREX.HIS<FX.CURRENCY.BOUGHT>
    END ELSE
        Y.CHARGE.CODE     = R.FOREX<FX.CHARGE.CODE>
        Y.FX.PAY.METHOD   = R.FOREX<FX.LOCAL.REF,L.FX.METHOD.POS>
        Y.CURRENCY1       = R.FOREX<FX.CURRENCY.SOLD>
        Y.CURRENCY2       = R.FOREX<FX.CURRENCY.BOUGHT>
    END
*
*20140111(S) - Removed the mandatory check of FT.PAY.METHOD as per the change request

    Y.METHOD = Y.FX.PAY.METHOD
    GOSUB GET.CHRG.DETAILS
*20140111(E)

*
RETURN
*---------------------------------------------------------------------------------------------
GET.CHRG.DETAILS:
*----------------
*

    LOOP
        REMOVE Y.CHRG.CODE FROM Y.CHARGE.CODE SETTING CHRG.POS
    WHILE Y.CHRG.CODE:CHRG.POS
*
        CALL F.READ(FN.FT.COMMISSION.TYPE,Y.CHRG.CODE,R.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE,Y.FT.COMM.ERR)
*
        IF R.FT.COMMISSION.TYPE NE '' THEN

            Y.DESCRIPTION    = R.FT.COMMISSION.TYPE<FT4.DESCRIPTION,Y.LANG.CODE>
            IF Y.DESCRIPTION EQ '' THEN
                Y.DESCRIPTION    = R.FT.COMMISSION.TYPE<FT4.DESCRIPTION>
            END

            Y.CATEG.ACCT     = R.FT.COMMISSION.TYPE<FT4.CATEGORY.ACCOUNT>
            Y.CURRENCY       = R.FT.COMMISSION.TYPE<FT4.CURRENCY>
            Y.FT.PERCENTAGE  = R.FT.COMMISSION.TYPE<FT4.PERCENTAGE>
            Y.CALC.TYPE      = R.FT.COMMISSION.TYPE<FT4.CALC.TYPE>
            Y.MIN.AMT        = R.FT.COMMISSION.TYPE<FT4.MINIMUM.AMT>
            Y.MAX.AMT        = R.FT.COMMISSION.TYPE<FT4.MAXIMUM.AMT>
        END
*
        CHANGE @SM TO @VM IN Y.FT.COMM
        LOCATE Y.CHRG.CODE IN Y.FT.COMM<1,1> SETTING Y.COMM.POS THEN

            IF Y.CATEG.ACCT GE Y.CATEG.FROM AND Y.CATEG.ACCT LE Y.CATEG.TO THEN
                GOSUB LOCATE.PAY.METHOD
            END
        END
    REPEAT

RETURN
*-------------------------------------------------------------------------------------------------------------
LOCATE.PAY.METHOD:
*-------------
*
    CHANGE @SM TO @VM IN Y.PAY.METHOD
    CHANGE @SM TO @VM IN Y.DISPLAY.CODES
    CHANGE @SM TO @VM IN Y.FX.PAY.METHOD.VAL
    CHANGE @SM TO @VM IN Y.FX.DISPLAY.CODES

    LOCATE Y.METHOD IN Y.PAY.METHOD<1,1> SETTING Y.METH.POS THEN
        Y.DIS.PAY.METHOD = Y.DISPLAY.CODES<1,Y.METH.POS>
    END ELSE
        LOCATE Y.METHOD IN Y.FX.PAY.METHOD.VAL<1,1> SETTING Y.METH.POS THEN
            Y.DIS.PAY.METHOD = Y.FX.DISPLAY.CODES<1,Y.METH.POS>
        END
    END
*
    GOSUB CHK.CCY
    GOSUB FORM.BODY

RETURN
*---------------------------------------------------------------------------------------------
CHK.CCY:
*-------
    CHANGE @SM TO @VM IN Y.CURRENCY
    IF Y.CURRENCY1 NE Y.CURRENCY2 THEN
        LOCATE Y.CURRENCY1 IN Y.CURRENCY<1,1> SETTING CUR.POS THEN
            Y.MAP.CCY = Y.CURRENCY1
        END ELSE
            LOCATE Y.CURRENCY2 IN Y.CURRENCY<1,1> SETTING CUR.POS THEN
                Y.MAP.CCY = Y.CURRENCY2
            END
        END
    END ELSE
        LOCATE Y.CURRENCY1 IN Y.CURRENCY<1,1> SETTING CUR.POS THEN
            Y.MAP.CCY = Y.CURRENCY1
        END
    END


RETURN
*----------------------------------------------------------------------------------------------
FORM.BODY:
*---------

    C$SPARE(451)= RIGHT(Y.CATEG.ACCT,3)
    C$SPARE(452)= Y.DESCRIPTION[1,30]

    IF Y.METHOD EQ 'TD' THEN
        C$SPARE(453) = '1'
    END ELSE
        C$SPARE(453) = ''
    END

    C$SPARE(454) = Y.DIS.PAY.METHOD
    C$SPARE(455) = Y.MAP.CCY


    CHANGE @SM TO @VM IN Y.FT.COMM.CODES
    Y.FT.COMM.CODE = Y.FT.COMM.CODES<1,Y.COMM.POS>
    Y.CONCEPT = FIELD(Y.FT.COMM.CODE,'-',1)
    C$SPARE(456) = Y.CONCEPT
    Y.FREQ = FIELD(Y.FT.COMM.CODE,'-',2)
    C$SPARE(457) = Y.FREQ


    Y.TOT.PER.CNT = DCOUNT(Y.FT.PERCENTAGE,@SM)
    IF Y.FT.PERCENTAGE NE '' THEN
        Y.INT = 1
        LOOP
        WHILE Y.INT LE Y.TOT.PER.CNT
            GOSUB GET.MAPPING.VALUES
            Y.INT += 1
        REPEAT
    END ELSE
        GOSUB GET.MAPPING.VALUES
    END

RETURN
*---------------------------------------------------------------------------------------------------------
GET.MAPPING.VALUES:
*-----------------
*

    IF Y.FT.PERCENTAGE<1,CUR.POS,Y.INT> NE '' THEN
        C$SPARE(458) = Y.PERCENTAGE
    END ELSE
        CHANGE @SM TO @VM IN Y.CALC.TYPE

        Y.CAL.TYPE = Y.CALC.TYPE<1,CUR.POS,Y.INT>
        LOCATE Y.CAL.TYPE IN Y.TYPE<1,1,1> SETTING Y.CALC.POS THEN
            C$SPARE(458) = Y.TYPE.CODE<1,1,Y.CALC.POS>
        END
    END

*
    IF Y.CALC.TYPE<1,CUR.POS,Y.INT> NE 'FLAT' THEN
        C$SPARE(459) = Y.MIN.AMT<1,CUR.POS,Y.INT>
        C$SPARE(460) = Y.MAX.AMT<1,CUR.POS,Y.INT>
    END
*
    GOSUB MAP.RCL.REC
*
RETURN
*---------------------------------------------------------------------------------------------
MAP.RCL.REC:
*-----------
*

    MAP.FMT = "MAP"
    ID.RCON.L = BATCH.DETAILS<3,1,2>
    APP = FN.FT.COMMISSION.TYPE
    R.APP = R.FT.COMMISSION.TYPE
    ID.APP = Y.CHRG.CODE
    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
    Y.ARRAY = R.RETURN.MSG
*

    IF Y.ARRAY THEN
        WRITESEQ Y.ARRAY APPEND TO SEQ.PTR ELSE
            Y.ERR.MSG = "Unable to Write '":Y.FILE.NAME:"'"
            GOSUB RAISE.ERR.C.22
            RETURN
        END
    END
*
RETURN
*---------------------------------------------------------------------------------------------
RAISE.ERR.C.22:
*--------------
*Handling error process
*----------------------
*
    MON.TP    = "13"
    REC.CON   = "TC01-":Y.ERR.MSG
    DESC      = "TC01-":Y.ERR.MSG
    INT.CODE  = 'REP001'
    INT.TYPE  = 'ONLINE'
    BAT.NO    = ''
    BAT.TOT   = ''
    INFO.OR   = ''
    INFO.DE   = ''
    ID.PROC   = ''
    EX.USER   = ''
    EX.PC     = ''
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
*
RETURN
*---------------------------------------------------------------------------------------------
END
*--

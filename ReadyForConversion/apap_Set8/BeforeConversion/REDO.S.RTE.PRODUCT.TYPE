* -----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>130</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.S.RTE.PRODUCT.TYPE(Y.OUT)
* --------------------------------------------------------------------------------
* Company   Name    :Asociacion Popular de Ahorros y Prestamos
* Developed By      :APAP
* Program   Name    :REDO.LAPAP.RTE.CREDIT.ACCOUNT
* ---------------------------------------------------------------------------------
* DESCRIPTION       :This program is used to get the credit account value
*  ----------------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT TAM.BP I_REDO.DEAL.SLIP.COMMON
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT LAPAP.BP I_F.REDO.RTE.CUST.CASHTXN
    $INSERT T24.BP I_F.TELLER
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INSERT TAM.BP I_F.REDO.RTE.CATEG.POSITION

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.RTE.CUST.CASHTXN = 'F.REDO.RTE.CUST.CASHTXN'
    F.REDO.RTE.CUST.CASHTXN = ''
    CALL OPF(FN.REDO.RTE.CUST.CASHTXN,F.REDO.RTE.CUST.CASHTXN)

    FN.REDO.RTE.CATEG.POS = 'F.REDO.RTE.CATEG.POSITION'
    F.REDO.RTE.CATEG.POS = ''
    CALL OPF(FN.REDO.RTE.CATEG.POS,F.REDO.RTE.CATEG.POS)

    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'
    F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    R.REDO.H.REPORTS.PARAM = ''
    RTE.PARAM.ERR = ''
    RTE.PARAM.ID = 'REDO.RTE.FORM'
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,RTE.PARAM.ID,R.REDO.H.REPORTS.PARAM,RTE.PARAM.ERR)
    IF R.REDO.H.REPORTS.PARAM THEN
        Y.FIELD.NME.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.NAME>
        Y.FIELD.VAL.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.FIELD.VALUE>
        Y.DISP.TEXT.ARR = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.DISPLAY.TEXT>
    END
    LOCATE "CASH.FX" IN Y.FIELD.NME.ARR<1,1> SETTING FX.VER.POS THEN
        Y.FX.VERSIONS = Y.FIELD.VAL.ARR<1,FX.VER.POS>
    END
    Y.FX.VERSIONS = CHANGE(Y.FX.VERSIONS,SM,VM)

    GOSUB PROCESS
    RETURN

PROCESS:

    Y.TXN.ACCOUNT = VAR.ACCOUNT
    IF LEN(Y.TXN.ACCOUNT) EQ 16 THEN

        FN.TELLER = 'F.TELLER'
        F.TELLER = ''
        CALL OPF(FN.TELLER,F.TELLER)
        FN.TELLER.NAU = 'F.TELLER$NAU'
        F.TELLER.NAU = ''
        CALL OPF(FN.TELLER.NAU,F.TELLER.NAU)

        CALL F.READ(FN.TELLER.NAU,ID.NEW,R.REC,F.TELLER.NAU,ERR.APPLICATION)
        IF R.REC EQ '' THEN
            ERR.APPLICATION = ""; R.REC = ""
            CALL F.READ(FN.TELLER,ID.NEW,R.REC,F.TELLER,ERR.APPLICATION)
        END
        IF R.REC THEN
            LRF.APP = 'TELLER'
            LRF.FIELD = 'L.ACTUAL.VERSIO'
            LRF.POS=''
            CALL MULTI.GET.LOC.REF(LRF.APP,LRF.FIELD,LRF.POS)
            L.ACTUAL.VERSIO.POS = LRF.POS<1,1>
            IF ID.NEW[1,2] EQ 'TT' THEN
                Y.ACT.VERSION = R.REC<TT.TE.LOCAL.REF><1,L.ACTUAL.VERSIO.POS>
                IF Y.ACT.VERSION THEN
                    LOCATE Y.ACT.VERSION IN Y.FX.VERSIONS<1,1> SETTING VER.CHK.POS THEN
                        Y.ACCT.1 = R.REC<TT.TE.ACCOUNT.1>
                        Y.ACCT.2 = R.REC<TT.TE.ACCOUNT.2>
                        BEGIN CASE
                        CASE VAR.ACCOUNT EQ Y.ACCT.1
                            Y.OUT = Y.ACCT.2
                            VAR.ACCOUNT = Y.OUT
                        CASE VAR.ACCOUNT EQ Y.ACCT.2
                            Y.OUT = Y.ACCT.1
                            VAR.ACCOUNT = Y.OUT
                        CASE OTHERWISE
                            Y.OUT = ''
                        END CASE
                    END
                END
            END
        END
    END

    GOSUB CHECK.CATEG.PRODUCT

    RETURN

********************
CHECK.CATEG.PRODUCT:
********************

    R.ACCOUNT = ''
    ACCOUNT.ERR = ''
    CALL F.READ(FN.ACCOUNT,VAR.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    IF R.ACCOUNT THEN
        Y.AC.CATEG = R.ACCOUNT<AC.CATEGORY>
    END

    R.RTE.CATEG.POS = ''
    CALL CACHE.READ(FN.REDO.RTE.CATEG.POS,"SYSTEM",R.RTE.CATEG.POS,CATEG.ERR)

    Y.RTE.POSITION = R.RTE.CATEG.POS<REDO.RTE.POS.RTE.POSITION>
    Y.CATEG.INIT   = R.RTE.CATEG.POS<REDO.RTE.POS.CATEG.INIT>
    Y.CATEG.END    = R.RTE.CATEG.POS<REDO.RTE.POS.CATEG.END>

    Y.RTE.POS.CNT = DCOUNT(Y.RTE.POSITION,@VM)
    FOR I = 1 TO Y.RTE.POS.CNT
        Y.CATEG.FROM = Y.CATEG.INIT<1,I>
        Y.CATEG.TO   = Y.CATEG.END<1,I>
        Y.CNT.CATEG = DCOUNT(Y.CATEG.FROM,SM)
        Y.CATEG = 1
        LOOP
        WHILE Y.CATEG LE Y.CNT.CATEG
            IF Y.AC.CATEG GE Y.CATEG.FROM<1,1,Y.CATEG> AND Y.AC.CATEG LE Y.CATEG.TO<1,1,Y.CATEG> THEN
                Y.OUT = R.RTE.CATEG.POS<REDO.RTE.POS.DESCRIPTION,I>
                Y.CATEG += Y.CNT.CATEG
                I += Y.RTE.POS.CNT
            END ELSE
                Y.OUT = 'Otras'
            END
            Y.CATEG += 1
        REPEAT
    NEXT I

    IF Y.OUT EQ 'Otras' THEN
        Y.OUT = ID.NEW
        CALL REDO.S.RTE.TXN.TYPE(Y.OUT)
    END

    RETURN

END

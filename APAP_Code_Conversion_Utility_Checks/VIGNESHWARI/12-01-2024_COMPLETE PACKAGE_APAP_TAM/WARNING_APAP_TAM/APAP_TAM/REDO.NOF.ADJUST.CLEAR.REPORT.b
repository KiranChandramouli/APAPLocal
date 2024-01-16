* @ValidationCode : Mjo4ODc2ODMxMDI6VVRGLTg6MTcwNDk1NjQxNTg0NzpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Jan 2024 12:30:15
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------
* <Rating>-231</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.NOF.ADJUST.CLEAR.REPORT(Y.FIN.ARR)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.NOF.ADJUST.CLEAR.REPORT
* ODR NUMBER    : ODR-2010-03-0134
*-----------------------------------------------------------------------------
* Description   : This is nofile routine, will fetch the values to pass to enquiry
* In parameter  : none
* out parameter : Y.FIN.ARR
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 25-03-2011      MARIMUTHU s     ODR-2010-03-0134   Initial Creation
* 17-02-2012      GANESH R        PACS00182172       Changed the routine to display only selected Adjust Debit and Credit Categories
* 28-03-2013      Arundev         PACS00260030       appended the value of adjustment type to final array
* 28.04.2023     Conversion Tool       R22            Auto Conversion     - No changes
* 28.04.2023     Shanmugapriya M       R22            Manual Conversion   - FM TO @FM, VM TO @VM, SM TO @SM
*
*------------------------------------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CLEARING.OUTWARD
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_F.REDO.APAP.CLEAR.PARAM
    $INSERT I_F.REDO.TFS.ALE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT

    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB LOCATE.DATE
    GOSUB Y.SORT.ARRAY
    GOSUB PROGRAM.END
*-----------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------
    FN.REDO.CLEARING.OUTWARD = 'F.REDO.CLEARING.OUTWARD'
    F.REDO.CLEARING.OUTWARD = ''
    CALL OPF(FN.REDO.CLEARING.OUTWARD,F.REDO.CLEARING.OUTWARD)

    FN.T24.FUND.SERVICES = 'F.T24.FUND.SERVICES'
    F.T24.FUND.SERVICES = ''
    CALL OPF(FN.T24.FUND.SERVICES,F.T24.FUND.SERVICES)

    FN.REDO.APAP.PARAM = 'F.REDO.APAP.CLEAR.PARAM'
    F.REDO.APAP.PARAM  = ''
    CALL OPF(FN.REDO.APAP.PARAM,F.REDO.APAP.PARAM)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.TFS.ALE = 'F.REDO.TFS.ALE'
    F.REDO.TFS.ALE  = ''
    CALL OPF(FN.REDO.TFS.ALE,F.REDO.TFS.ALE)

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    LOC.APPLICATION = 'T24.FUND.SERVICES'
    LOC.FIELDS = 'L.TT.NO.OF.CHQ'
    LOC.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.APPLICATION,LOC.FIELDS,LOC.POS)
    LOC.CHQ.NO = LOC.POS<1,1>
    Y.VAL.SEQUENCE = ''
    SEL.CMD = 'SELECT ':FN.REDO.CLEARING.OUTWARD:' WITH ROUTE.NO LIKE 4444...'

    LOCATE 'ADJUSTMENT' IN D.FIELDS SETTING POS.ADJ THEN
        Y.ADJ.SET = 'Y'
        Y.ADJSMNT = D.RANGE.AND.VALUE<POS.ADJ>
        IF Y.ADJSMNT EQ 'CREDITO' THEN
            SEL.CMD := ' WITH (CATEGORY EQ 316 OR CATEGORY EQ 651 OR CATEGORY EQ 751)'
        END
        IF Y.ADJSMNT EQ 'DEBITO' THEN
            SEL.CMD := ' WITH (CATEGORY EQ 314 OR CATEGORY EQ 641 OR CATEGORY EQ 741)'
        END
        IF (Y.ADJSMNT NE 'DEBITO') AND (Y.ADJSMNT NE 'CREDITO') THEN
            SEL.CMD = ''
        END
    END
    LOCATE 'ACCOUNT' IN D.FIELDS SETTING POS.AC THEN
        Y.AC.SET = 'Y'
        Y.ACCOUNT = D.RANGE.AND.VALUE<POS.AC>
        IF Y.ADJ.SET EQ 'Y' THEN
            SEL.CMD := 'AND (ACCOUNT EQ ':Y.ACCOUNT:')'
        END ELSE
            SEL.CMD := ' WITH ACCOUNT EQ ':Y.ACCOUNT
        END
    END
    LOCATE 'CURRENCY' IN D.FIELDS SETTING CCY.POS THEN
        Y.CCY = D.RANGE.AND.VALUE<CCY.POS>
        SEL.CMD := ' AND CURRENCY EQ ':Y.CCY
    END
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,ERR.TEMP)

RETURN
*-----------------------------------------------------------------------------
LOCATE.DATE:
*-----------------------------------------------------------------------------
    LOCATE 'DATE' IN D.FIELDS SETTING POS.DATE THEN
        Y.DATE = D.RANGE.AND.VALUE<POS.DATE>

        IF INDEX(Y.DATE, @SM,1) THEN
            Y.S.DATE = FIELD(Y.DATE,@SM,1)
            Y.E.DATE = FIELD(Y.DATE,@SM,2)
        END

        Y.OPR = D.LOGICAL.OPERANDS<POS.DATE>
        Y.CK.DATE = Y.DATE
        Y.DATE.SET = 'Y'
        GOSUB FOR.HEADER.CLASSI
        BEGIN CASE
            CASE Y.OPR EQ 1
                GOSUB SUB.PROCESS.EQ
            CASE Y.OPR EQ 2
                GOSUB SUB.PROCESS.RG
            CASE Y.OPR EQ 3
                GOSUB SUB.PROCESS.LT
            CASE Y.OPR EQ 4
                GOSUB SUB.PROCESS.GT
            CASE Y.OPR EQ 8
                GOSUB SUB.PROCESS.LE
            CASE Y.OPR EQ 9
                GOSUB SUB.PROCESS.GE
        END CASE

    END ELSE
        GOSUB ELSE.DATE
    END

RETURN
*-----------------------------------------------------------------------------
ELSE.DATE:
*-----------------------------------------------------------------------------
    GOSUB FOR.HEADER.CLASSI
    LOOP
        REMOVE Y.ID FROM SEL.LIST SETTING POS.ID
    WHILE Y.ID:POS.ID
        CALL F.READ(FN.REDO.CLEARING.OUTWARD,Y.ID,R.REDO.CLEARING.OUTWARD,F.REDO.CLEARING.OUTWARD,CLR.OU.ERR)
        GOSUB CHECK.DEBIT.CREDIT
        IF Y.CAT.FLAG THEN
            GOSUB GET.VALUES.CLEARING
        END
    REPEAT

RETURN
*-----------------------------------------------------------------------------
FOR.HEADER.CLASSI:
*-----------------------------------------------------------------------------

    BEGIN CASE
        CASE Y.ADJ.SET EQ 'Y' AND Y.AC.SET EQ 'Y' AND Y.DATE.SET EQ 'Y'
            IF Y.OPR EQ 2 THEN
                Y.DUP.CK.DATE.S = Y.S.DATE
*            Y.DUP.CK.DATE.S = OCONV(Y.DUP.CK.DATE.S,'D')
                Y.DUP.CK.DATE.E = Y.E.DATE
*            Y.DUP.CK.DATE.E = OCONV(Y.DUP.CK.DATE.E,'D')

                Y.TEMP.DATE.1 = Y.DUP.CK.DATE.S
                CALL EB.DATE.FORMAT.DISPLAY(Y.TEMP.DATE.1, Y.DUP.CK.DATE.S, '', '')

                Y.TEMP.DATE.2 = Y.DUP.CK.DATE.E
                CALL EB.DATE.FORMAT.DISPLAY(Y.TEMP.DATE.2, Y.DUP.CK.DATE.E, '', '')

                Y.ENQ.VALS = 'MONEDA: ':Y.CCY:',FECHA: ':Y.DUP.CK.DATE.S:' - ':Y.DUP.CK.DATE.E:',':'NO. DE CUENTA: ':Y.ACCOUNT:',':'TIPO DE AJUSTE: ':Y.ADJSMNT
            END ELSE
*            Y.CK.DATE = ICONV(Y.CK.DATE,'D')
*            Y.CK.DATE = OCONV(Y.CK.DATE,'D')

                Y.TEMP.CK.DATE = Y.CK.DATE
                CALL EB.DATE.FORMAT.DISPLAY(Y.TEMP.CK.DATE, Y.CK.DATE, '', '')

                Y.ENQ.VALS = 'MONEDA: ':Y.CCY:',FECHA: ':Y.CK.DATE:',':'NO. DE CUENTA: ':Y.ACCOUNT:',':'TIPO DE AJUSTE: ':Y.ADJSMNT
            END

        CASE Y.ADJ.SET EQ 'Y' AND Y.AC.SET EQ 'Y' AND Y.DATE.SET NE 'Y'
            Y.ENQ.VALS = 'MONEDA: ':Y.CCY:',NO. DE CUENTA: ':Y.ACCOUNT:',':'TIPO DE AJUSTE: ':Y.ADJSMNT

        CASE Y.ADJ.SET EQ 'Y' AND Y.AC.SET NE 'Y' AND Y.DATE.SET EQ 'Y'
            GOSUB CASE.SET.3

        CASE Y.ADJ.SET NE 'Y' AND Y.AC.SET EQ 'Y' AND Y.DATE.SET EQ 'Y'
            GOSUB CASE.AC.SET.AL

        CASE Y.ADJ.SET NE 'Y' AND Y.AC.SET NE 'Y' AND Y.DATE.SET EQ 'Y'
            GOSUB CASE.DATE.ALONE

        CASE Y.ADJ.SET EQ 'Y' AND Y.AC.SET NE 'Y' AND Y.DATE.SET NE 'Y'
            Y.ENQ.VALS = 'MONEDA: ':Y.CCY:',TIPO DE AJUSTE: ':Y.ADJSMNT

        CASE Y.ADJ.SET NE 'Y' AND Y.AC.SET EQ 'Y' AND Y.DATE.SET NE 'Y'
            Y.ENQ.VALS = 'MONEDA: ':Y.CCY:',NO. DE CUENTA: ':Y.ACCOUNT

        CASE Y.ADJ.SET NE 'Y' AND Y.AC.SET NE 'Y' AND Y.DATE.SET NE 'Y'
            Y.ENQ.VALS = 'MONEDA: ':Y.CCY:

    END CASE

RETURN
*-----------------------------------------------------------------------------
CASE.DATE.ALONE:
*-----------------------------------------------------------------------------
    IF Y.OPR EQ 2 THEN

        Y.DUP.CK.DATE.S = Y.S.DATE
*        Y.DUP.CK.DATE.S = OCONV(Y.DUP.CK.DATE.S,'D')
        Y.DUP.CK.DATE.E = Y.E.DATE
*        Y.DUP.CK.DATE.E = OCONV(Y.DUP.CK.DATE.E,'D')

        Y.TEMP.DATE.1 = Y.DUP.CK.DATE.S
        CALL EB.DATE.FORMAT.DISPLAY(Y.TEMP.DATE.1, Y.DUP.CK.DATE.S, '', '')

        Y.TEMP.DATE.2 = Y.DUP.CK.DATE.E
        CALL EB.DATE.FORMAT.DISPLAY(Y.TEMP.DATE.2, Y.DUP.CK.DATE.E, '', '')

        Y.ENQ.VALS = 'MONEDA: ':Y.CCY:',FECHA: ':Y.DUP.CK.DATE.S:' - ':Y.DUP.CK.DATE.E
    END ELSE
*        Y.CK.DATE = ICONV(Y.CK.DATE,'D')
*        Y.CK.DATE = OCONV(Y.CK.DATE,'D')

        Y.TEMP.CK.DATE = Y.CK.DATE
        CALL EB.DATE.FORMAT.DISPLAY(Y.TEMP.CK.DATE, Y.CK.DATE, '', '')

        Y.ENQ.VALS = 'MONEDA: ':Y.CCY:',FECHA: ':Y.CK.DATE
    END

RETURN
*-----------------------------------------------------------------------------
CASE.AC.SET.AL:
*-----------------------------------------------------------------------------
    IF Y.OPR EQ 2 THEN
        Y.DUP.CK.DATE.S = Y.S.DATE
*        Y.DUP.CK.DATE.S = OCONV(Y.DUP.CK.DATE.S,'D')
        Y.DUP.CK.DATE.E = Y.E.DATE
*        Y.DUP.CK.DATE.E = OCONV(Y.DUP.CK.DATE.E,'D')

        Y.TEMP.DATE.1 = Y.DUP.CK.DATE.S
        CALL EB.DATE.FORMAT.DISPLAY(Y.TEMP.DATE.1, Y.DUP.CK.DATE.S, '', '')

        Y.TEMP.DATE.2 = Y.DUP.CK.DATE.E
        CALL EB.DATE.FORMAT.DISPLAY(Y.TEMP.DATE.2, Y.DUP.CK.DATE.E, '', '')

        Y.ENQ.VALS = 'MONEDA: ':Y.CCY:',FECHA: ':Y.DUP.CK.DATE.S:' - ':Y.DUP.CK.DATE.E:',':'NO. DE CUENTA: ':Y.ACCOUNT
    END ELSE
*        Y.CK.DATE = ICONV(Y.CK.DATE,'D')
*        Y.CK.DATE = OCONV(Y.CK.DATE,'D')

        Y.TEMP.CK.DATE = Y.CK.DATE
        CALL EB.DATE.FORMAT.DISPLAY(Y.TEMP.CK.DATE, Y.CK.DATE, '', '')

        Y.ENQ.VALS = 'MONEDA: ':Y.CCY:',FECHA: ':Y.CK.DATE:',':'NO. DE CUENTA: ':Y.ACCOUNT
    END

RETURN
*-----------------------------------------------------------------------------
CASE.SET.3:
*-----------------------------------------------------------------------------
    IF Y.OPR EQ 2 THEN
        Y.DUP.CK.DATE.S = Y.S.DATE
*        Y.DUP.CK.DATE.S = OCONV(Y.DUP.CK.DATE.S,'D')
        Y.DUP.CK.DATE.E = Y.E.DATE
*        Y.DUP.CK.DATE.E = OCONV(Y.DUP.CK.DATE.E,'D')

        Y.TEMP.DATE.1 = Y.DUP.CK.DATE.S
        CALL EB.DATE.FORMAT.DISPLAY(Y.TEMP.DATE.1, Y.DUP.CK.DATE.S, '', '')

        Y.TEMP.DATE.2 = Y.DUP.CK.DATE.E
        CALL EB.DATE.FORMAT.DISPLAY(Y.TEMP.DATE.2, Y.DUP.CK.DATE.E, '', '')

        Y.ENQ.VALS = 'MONEDA: ':Y.CCY:',FECHA: ':Y.DUP.CK.DATE.S:' - ':Y.DUP.CK.DATE.E:',':'TIPO DE AJUSTE: ':Y.ADJSMNT
    END ELSE
*        Y.CK.DATE = ICONV(Y.CK.DATE,'D')
*        Y.CK.DATE = OCONV(Y.CK.DATE,'D')

        Y.TEMP.CK.DATE = Y.CK.DATE
        CALL EB.DATE.FORMAT.DISPLAY(Y.TEMP.CK.DATE, Y.CK.DATE, '', '')

        Y.ENQ.VALS = 'MONEDA: ':Y.CCY:',FECHA: ':Y.CK.DATE:',':'TIPO DE AJUSTE: ':Y.ADJSMNT
    END

RETURN
*-----------------------------------------------------------------------------
GET.VALUES.CLEARING:
*-----------------------------------------------------------------------------
    Y.DIS.DEB.AMT = 0
    Y.DIS.CRE.AMT = 0
    Y.DIS.DATE = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.DATE.TIME>
    Y.DIS.DATE = TODAY[1,2]:Y.DIS.DATE[1,6]
    Y.TEMP.DATE= Y.DIS.DATE

*    Y.DIS.DATE = ICONV(Y.DIS.DATE,'D')
*    Y.DIS.DATE = OCONV(Y.DIS.DATE,'D')

    Y.TEMP.DIS.DATE = Y.DIS.DATE
    CALL EB.DATE.FORMAT.DISPLAY(Y.TEMP.DIS.DATE, Y.DIS.DATE, '', '')

    Y.AC.VAL = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.ACCOUNT>
    Y.SEQUENCE = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.SEQUENCE>
    LOCATE Y.SEQUENCE IN Y.VAL.SEQUENCE SETTING Y.VAL.POS ELSE
        Y.VAL.SEQUENCE<-1> = Y.SEQUENCE
    END
    CALL F.READ(FN.ACCOUNT,Y.AC.VAL,R.ACCOUNT,F.ACCOUNT,AC.ERR)
    Y.NAME = R.ACCOUNT<AC.ACCOUNT.TITLE.1>
    Y.CATEGORY = R.ACCOUNT<AC.CATEGORY>
    Y.CURRENCY = R.ACCOUNT<AC.CURRENCY>
    Y.SORT.VAR = Y.TEMP.DATE:Y.AC.VAL
    Y.AC.OFFICER = R.ACCOUNT<AC.ACCOUNT.OFFICER>
    Y.TXN.REF = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.TXN.REFERENCE>
    Y.TELLER.ID = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.TELLER.ID>
    Y.TEMP.CATEG = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.CATEGORY>
    Y.TFS.REF = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.TFS.REFERENCE>
*    CALL CACHE.READ(FN.REDO.APAP.PARAM,'SYSTEM',R.REDO.APAP.PARAM,PARAM.ERR)
    IDVAR.1 = 'SYSTEM' ;* R22 UTILITY AUTO CONVERSION
    CALL CACHE.READ(FN.REDO.APAP.PARAM,IDVAR.1,R.REDO.APAP.PARAM,PARAM.ERR);* R22 UTILITY AUTO CONVERSION
    Y.LOC.TXN.TYPES = R.REDO.APAP.PARAM<CLEAR.PARAM.TT.FT.TRAN.TYPE>
    CHANGE @VM TO @FM IN Y.LOC.TXN.TYPES
    IF Y.TFS.REF[1,3] EQ 'T24' THEN
        CALL F.READ(FN.T24.FUND.SERVICES,Y.TFS.REF,R.T24.FUND.SERVICES,F.T24.FUND.SERVICES,TFS.ERR)
        Y.TFS.TRANS = R.T24.FUND.SERVICES<TFS.TRANSACTION>
        VAR.NO.OF.CHQS = R.T24.FUND.SERVICES<TFS.LOCAL.REF,LOC.CHQ.NO>
        Y.TFS.INIT = 1
        Y.TFS.COUNT = DCOUNT(Y.LOC.TXN.TYPES,@FM)
        LOOP
            REMOVE Y.TFS.TYPE FROM Y.LOC.TXN.TYPES SETTING Y.TFS.POS
        WHILE Y.TFS.INIT LE Y.TFS.COUNT
            LOCATE Y.TFS.TYPE IN Y.TFS.TRANS<1,1> SETTING POS.TRNS THEN
                Y.TOT.AMOUNT = R.T24.FUND.SERVICES<TFS.AMOUNT,POS.TRNS>
                Y.TOT.AMOUNT = SUM(Y.TOT.AMOUNT)
            END
            Y.TFS.INIT++
        REPEAT
        Y.USER.INP = R.T24.FUND.SERVICES<TFS.INPUTTER>
        Y.USER.INP = FIELD(Y.USER.INP,'_',2)
    END
    Y.CRED.FLAG = 0
    Y.DEB.FLAG  = 0
    IF Y.TEMP.CATEG EQ '316' OR Y.TEMP.CATEG EQ '651' OR Y.TEMP.CATEG EQ '751' THEN
        Y.DIFF.TYPE = 'SOBRANTE'
        Y.ADJ.TYPE = 'CREDITO'
        Y.CRED.FLAG = 1
        Y.DIS.CRE.AMT = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.AMOUNT>
        Y.REAL.AMT = Y.TOT.AMOUNT + Y.DIS.CRE.AMT
    END
    IF Y.TEMP.CATEG EQ '314' OR Y.TEMP.CATEG EQ '641' OR Y.TEMP.CATEG EQ '741' THEN
        Y.DIFF.TYPE = 'FALTANTE'
        Y.ADJ.TYPE = 'DEBITO'
        Y.DEB.FLAG = 1
        Y.DIS.DEB.AMT = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.AMOUNT>
        Y.REAL.AMT = Y.TOT.AMOUNT - Y.DIS.DEB.AMT
    END
    Y.NO.OF.CHEQ = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.NO.OF.CHEQUE>
    Y.CHEQUE.NO    = ''
    Y.DRAW.AC      = ''
    Y.AMOUNT.DIS.2 = ''

    Y.DRAWN.BANK = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.ROUTE.NO>
    Y.USER.CL.INP = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.INPUTTER>
    Y.USER.CL.INP = FIELD(Y.USER.CL.INP,'_',2)
    Y.USER.CL.AUT = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.AUTHORISER>
    Y.USER.CL.AUT = FIELD(Y.USER.CL.AUT,'_',2)
    GOSUB OTHER.CHQ.VALUES

    Y.USER.CL.INP = FIELD(Y.USER.CL.INP,@VM,1)       ;*PACS00260030
    Y.USER.CL.AUT = FIELD(Y.USER.CL.AUT,@VM,1)       ;*PACS00260030

*                       1             2              3            4              5               6               7             8               9             10              11              12               13               14               15          16
    Y.FIN.ARR<-1> = Y.SORT.VAR:'*':Y.DIS.DATE:'*':Y.AC.VAL:'*':Y.NAME:'*':Y.CATEGORY:'*':Y.CURRENCY:'*':Y.AC.OFFICER:'*':Y.TXN.REF:'*':Y.TELLER.ID:'*':Y.DIFF.TYPE:'*':Y.TOT.AMOUNT:'*':Y.REAL.AMT:'*':VAR.NO.OF.CHQS:'*':Y.USER.INP:'*':Y.DIS.DEB.AMT:'*':Y.DIS.CRE.AMT:'*'
*                    17              18             19                20                21                22               23             24              25                   26                                               27
    Y.FIN.ARR := Y.CHEQUE.NO:'*':Y.DRAW.AC:'*':Y.AMOUNT.DIS.2:'*':Y.DRAWN.BANK:'*':Y.USER.CL.INP:'*':Y.USER.CL.AUT:'*':Y.DEB.FLAG:'*':Y.CRED.FLAG:'*':Y.ENQ.VALS:'*':'REPORTE DE AJUSTES POR DIFERENCIAS EN DEPOSITOS':'*':OCONV(TIME(),'MTS')
*                     28                   29
    Y.FIN.ARR := '*':Y.ADJ.TYPE:'*':Y.REAL.CK.CNT   ;*PACS00260030

    Y.DIS.DATE = ''; Y.AC.VAL = ''; Y.NAME = ''; Y.CATEGORY = ''; Y.CATEGORY = ''; Y.CURRENCY = ''; Y.AC.OFFICER = ''; Y.TXN.REF = ''; Y.TELLER.ID = ''; Y.DIFF.TYPE = ''; Y.TOT.AMOUNT = ''; Y.NO.OF.CHEQ = ''; Y.ADJ.TYPE = ''; Y.USER.INP = '';
    Y.DIS.AMT = ''; Y.CHEQUE.NO = ''; Y.DRAW.AC = '' ; Y.AMOUNT.DIS.2 = ''; Y.DRAWN.BANK = '' ; Y.USER.CL.INP = ''; Y.USER.CL.AUT = ''

RETURN

*-----------------------------------------------------------------------------
SUB.PROCESS.EQ:
*-----------------------------------------------------------------------------
    LOOP
        REMOVE Y.ID FROM SEL.LIST SETTING POS.ID
    WHILE Y.ID:POS.ID
        CALL F.READ(FN.REDO.CLEARING.OUTWARD,Y.ID,R.REDO.CLEARING.OUTWARD,F.REDO.CLEARING.OUTWARD,CLR.OU.ERR)
        Y.DATE.TIME = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.DATE.TIME>
        GOSUB CHECK.DEBIT.CREDIT
        Y.DUP.DATE = TODAY[1,2]:Y.DATE.TIME[1,6]
        IF Y.DUP.DATE EQ Y.DATE AND Y.CAT.FLAG THEN
            GOSUB GET.VALUES.CLEARING
        END
    REPEAT

RETURN
*-----------------------------------------------------------------------------
SUB.PROCESS.LT:
*-----------------------------------------------------------------------------
    LOOP
        REMOVE Y.ID FROM SEL.LIST SETTING POS.ID
    WHILE Y.ID:POS.ID
        CALL F.READ(FN.REDO.CLEARING.OUTWARD,Y.ID,R.REDO.CLEARING.OUTWARD,F.REDO.CLEARING.OUTWARD,CLR.OU.ERR)
        Y.DATE.TIME = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.DATE.TIME>
        GOSUB CHECK.DEBIT.CREDIT
        Y.DUP.DATE = TODAY[1,2]:Y.DATE.TIME[1,6]
        IF Y.DUP.DATE LT Y.DATE AND Y.CAT.FLAG THEN
            GOSUB GET.VALUES.CLEARING
        END
    REPEAT

RETURN
*-----------------------------------------------------------------------------
SUB.PROCESS.GT:
*-----------------------------------------------------------------------------
    LOOP
        REMOVE Y.ID FROM SEL.LIST SETTING POS.ID
    WHILE Y.ID:POS.ID
        CALL F.READ(FN.REDO.CLEARING.OUTWARD,Y.ID,R.REDO.CLEARING.OUTWARD,F.REDO.CLEARING.OUTWARD,CLR.OU.ERR)
        Y.DATE.TIME = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.DATE.TIME>
        GOSUB CHECK.DEBIT.CREDIT
        Y.DUP.DATE = TODAY[1,2]:Y.DATE.TIME[1,6]
        IF Y.DUP.DATE GT Y.DATE AND Y.CAT.FLAG THEN
            GOSUB GET.VALUES.CLEARING
        END
    REPEAT

RETURN
*-----------------------------------------------------------------------------
SUB.PROCESS.LE:
*-----------------------------------------------------------------------------
    LOOP
        REMOVE Y.ID FROM SEL.LIST SETTING POS.ID
    WHILE Y.ID:POS.ID
        CALL F.READ(FN.REDO.CLEARING.OUTWARD,Y.ID,R.REDO.CLEARING.OUTWARD,F.REDO.CLEARING.OUTWARD,CLR.OU.ERR)
        Y.DATE.TIME = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.DATE.TIME>
        Y.DUP.DATE = TODAY[1,2]:Y.DATE.TIME[1,6]
        IF Y.DUP.DATE LE Y.DATE AND Y.CAT.FLAG THEN
            GOSUB GET.VALUES.CLEARING
        END
    REPEAT

RETURN
*-----------------------------------------------------------------------------
SUB.PROCESS.GE:
*-----------------------------------------------------------------------------
    LOOP
        REMOVE Y.ID FROM SEL.LIST SETTING POS.ID
    WHILE Y.ID:POS.ID
        CALL F.READ(FN.REDO.CLEARING.OUTWARD,Y.ID,R.REDO.CLEARING.OUTWARD,F.REDO.CLEARING.OUTWARD,CLR.OU.ERR)
        Y.DATE.TIME = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.DATE.TIME>
        GOSUB CHECK.DEBIT.CREDIT
        Y.DUP.DATE = TODAY[1,2]:Y.DATE.TIME[1,6]
        IF Y.DUP.DATE GE Y.DATE AND Y.CAT.FLAG THEN
            GOSUB GET.VALUES.CLEARING
        END
    REPEAT

RETURN
*-----------------------------------------------------------------------------
SUB.PROCESS.RG:
*-----------------------------------------------------------------------------
    Y.S.DATE = FIELD(Y.DATE,@SM,1)
    Y.E.DATE = FIELD(Y.DATE,@SM,2)
    LOOP
        REMOVE Y.ID FROM SEL.LIST SETTING POS.ID
    WHILE Y.ID:POS.ID
        CALL F.READ(FN.REDO.CLEARING.OUTWARD,Y.ID,R.REDO.CLEARING.OUTWARD,F.REDO.CLEARING.OUTWARD,CLR.OU.ERR)
        Y.DATE.TIME = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.DATE.TIME>
        GOSUB CHECK.DEBIT.CREDIT
        Y.DUP.DATE = TODAY[1,2]:Y.DATE.TIME[1,6]
        IF Y.DUP.DATE GE Y.S.DATE AND Y.DUP.DATE LE Y.E.DATE AND Y.CAT.FLAG THEN
            GOSUB GET.VALUES.CLEARING
        END
    REPEAT

RETURN
*-----------------------------------------------------------------------------
CHECK.DEBIT.CREDIT:
    Y.CAT.FLAG = ''
    Y.CATEG = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.CATEGORY>
    IF Y.CATEG EQ '316' OR Y.CATEG EQ '651' OR Y.CATEG EQ '751' OR Y.CATEG EQ '314' OR Y.CATEG EQ '641' OR Y.CATEG EQ '741' THEN
        Y.CAT.FLAG = 1
    END
RETURN
*---------------------------------------------------------------------------------------------------------
OTHER.CHQ.VALUES:
    Y.LOOP.INIT  = 2
    Y.LOOP.COUNT = VAR.NO.OF.CHQS + 1
    CALL F.READ(FN.REDO.TFS.ALE,Y.TFS.REF,R.REDO.TFS.ALE,F.REDO.TFS.ALE,TFS.ALE.ERR)
    Y.VAR.CLEAR.IDS = R.REDO.TFS.ALE<TFS.ALE.REDO.CLEAR.OUT>
    Y.CHEQUE.NO    = ''
    Y.DRAW.AC      = ''
    Y.AMOUNT.DIS.2 = ''
    Y.REAL.CK.CNT = 0
    LOOP
        REMOVE Y.CLEAR.ID FROM Y.VAR.CLEAR.IDS SETTING CLEAR.POS
    WHILE Y.CLEAR.ID : CLEAR.POS
        Y.CHECK = Y.CLEAR.ID[1,6]
        IF Y.CHECK NE 'ADJUST' THEN
            CALL F.READ(FN.REDO.CLEARING.OUTWARD,Y.CLEAR.ID,R.CLEARING.REC,F.REDO.CLEARING.OUTWARD,CLR.ERR)
            Y.CHEQUE.NO<1,-1>    = R.CLEARING.REC<CLEAR.OUT.CHEQUE.NO>
            Y.DRAW.AC<1,-1>      = R.CLEARING.REC<CLEAR.OUT.DRAWER.ACCT>
            Y.AMOUNT.DIS.2<1,-1> = R.CLEARING.REC<CLEAR.OUT.AMOUNT>
            Y.DRAWN.BANK<1,-1>   = R.CLEARING.REC<CLEAR.OUT.ROUTE.NO>
            Y.USER.TEM.INP       = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.INPUTTER>
            Y.USER.CL.INP<1,-1>  = FIELD(Y.USER.TEM.INP,'_',2)
            Y.USER.TEM.AUT       = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.AUTHORISER>
            Y.USER.CL.AUT<1,-1>  = FIELD(Y.USER.TEM.AUT,'_',2)
            Y.REAL.CK.CNT++
        END
        Y.LOOP.INIT++
    REPEAT
    INS '' BEFORE Y.CHEQUE.NO<1,1>
    INS '' BEFORE Y.DRAW.AC<1,1>
    INS '' BEFORE Y.AMOUNT.DIS.2<1,1>
RETURN

*------------------------------------------------------------------------------------------------------------
Y.SORT.ARRAY:

    Y.REC.COUNT = DCOUNT(Y.FIN.ARR,@FM)
    Y.REC.START = 1
    LOOP
    WHILE Y.REC.START LE Y.REC.COUNT
        Y.REC = Y.FIN.ARR<Y.REC.START>
        Y.COMP = FIELD(Y.REC,'*',1)

        Y.SORT.VAL = Y.COMP
        Y.AZ.SORT.VAL<-1> = Y.REC:@FM:Y.SORT.VAL
        Y.SORT.ARR<-1>= Y.SORT.VAL
        Y.REC.START += 1
    REPEAT
    Y.SORT.ARR = SORT(Y.SORT.ARR)
    LOOP
        REMOVE Y.ARR.ID FROM Y.SORT.ARR SETTING Y.ARR.POS
    WHILE Y.ARR.ID : Y.ARR.POS
        LOCATE Y.ARR.ID IN Y.AZ.SORT.VAL SETTING Y.FM.POS THEN
            Y.OUT.ARRAY<-1> = Y.AZ.SORT.VAL<Y.FM.POS-1>
            DEL Y.AZ.SORT.VAL<Y.FM.POS>
            DEL Y.AZ.SORT.VAL<Y.FM.POS-1>
        END
    REPEAT
    Y.FIN.ARR = Y.OUT.ARRAY
RETURN

*-----------------------------------------------------------------------------
PROGRAM.END:
*-----------------------------------------------------------------------------
END

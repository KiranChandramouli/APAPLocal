* @ValidationCode : MjotMjg1NzkzMjQ0OkNwMTI1MjoxNjg1NjIyNDA5MzQyOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 01 Jun 2023 17:56:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.CR.GUARANTEE(Y.FINAL.ARR)
*-----------------------------------------------------------------------------
*
* Developed By            : Vijayarani G
*
* Developed On            : 30-SEP-2013
*
* Development Reference   : 786711(FS-200-DE03)
*
* Development Description : A report containing information on the Collaterals that support the various
*                           Loans reported by the Bank will be developed.
*
* Attached To             : BATCH>BNK/REDO.B.CR.GUARANTEE
*
* Attached As             : COB Routine
*
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*
*-----------------------------------------------------------------------------------------------------------------
* PACS00353058          Ashokkumar.V.P                  11/11/2014           Changes the fields based on new mapping
* PACS00460181          Ashokkumar.V.P                  26/05/2015           Changes the fields based on new mapping
* PACS00460181          Ashokkumar.V.P                  02/06/2015           Changes the fields based on new mapping
* PACS00460181          Ashokkumar.V.P                  10/06/2015           Changes the fields based on new mapping
* NPLA006005            Bienvenido R.                   30/03/2017           Agregando nuevos campos
* CI008098              Ashokkumar.V.P                  04/01/2018           Ajustar el descripción de la garantía de créditos Hipotecarios
*
* 21-APR-2023            Conversion tool            R22 Auto conversion      FM TO @FM, VM to @VM, SM to @SM, ++ to +=, -- to -=, I to I.VAR
* 21-APR-2023             Harishvikram C            Manual R22 conversion    AA.AH.ACTIVITY.ID to AA.AH.ACTIVITY.REF, CALL routine format modified, L.AA.COL.VAL.POS,L.COL.INVST.NO.POS,L.COL.NUM.INSTR.POS,Y.L.CR.FACILITY.POS,Y.INSP.VAL.ARR,Y.TODATE,L.COL.ENTY.INS.POS,L.COL.DEBTOR.NA.POS,L.AC.LK.COL.ID.POS,Y.VALU.NAM.POS,Y.GRTA.FID.POS,Y.CLA.FIDE.POS,Y.DES.FIDE.POS  added in Insert file I_REDO.B.CR.GUARANTEE.COMMON
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.COLLATERAL.TYPE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_REDO.B.CR.GUARANTEE.COMMON
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_F.REDO.H.CUSTOMER.PROVISIONING
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.EB.LOOKUP
    
    $USING APAP.TAM
    $USING APAP.REDOSRTN


* </region>
*-----------------------------------------------------------------------------
*
    GOSUB MAIN.PROCESS
RETURN
*
*--------------
MAIN.PROCESS:
**-----------
    Y.AA.ARR.ID = Y.FINAL.ARR
    ARR.ERR       = ""; R.AA.ARRANGEMENT = ""
    L.APAP.POLIZA.ID = ""
    CALL AA.GET.ARRANGEMENT(Y.AA.ARR.ID,R.AA.ARRANGEMENT,ARR.ERR)
    Y.IN.DATE  = ""; Y.OUT.DATE = ""; COLLATERAL.ID = ''; C$SPARE(451) = ''
    ARR.ID     = Y.AA.ARR.ID
    Y.MAIN.ARR.STATUS = R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS>
    YSTART.DTE = R.AA.ARRANGEMENT<AA.ARR.START.DATE>
    Y.PROD.GUP = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    Y.AA.PROD = R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
    YAA.CUSTOMER = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>

    IF YSTART.DTE GT YL.TODAY THEN
        RETURN
    END
    IF Y.MAIN.ARR.STATUS NE 'CURRENT' AND Y.MAIN.ARR.STATUS NE 'EXPIRED' THEN
        RETURN
    END
    PROP.CLASS = 'TERM.AMOUNT';    PROP.NAME  = ''; returnConditions = ''; RET.ERR = ''
    COLLATERAL.ID = ''; YL.AA.COL.VAL = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ARR.ID,PROP.CLASS,PROP.NAME,'','',returnConditions,ERR.COND)
    R.AA.TERM.AMOUNT = RAISE(returnConditions)
    COLLATERAL.ID = R.AA.TERM.AMOUNT<AA.AMT.LOCAL.REF,L.AA.COL.POS>
    IF NOT(COLLATERAL.ID) THEN
        GOSUB FIND.COLL.VAL
        COLLATERAL.ID = R.AA.TERM.AMOUNT<AA.AMT.LOCAL.REF,L.AA.COL.POS>
        IF NOT(COLLATERAL.ID) THEN
            RETURN
        END
    END

    YL.AA.COL.VAL = R.AA.TERM.AMOUNT<AA.AMT.LOCAL.REF,L.AA.COL.VAL.POS>
    ARRAY.VAL = ''; Y.LOAN.STATUS = ''; Y.CLOSE.LN.FLG = 0; YPROCS = 0
    APAP.TAM.redoRptClseWriteLoans(Y.AA.ARR.ID,R.AA.ARRANGEMENT,ARRAY.VAL);*MANUAL R22 CODE CONVERSION
    Y.LOAN.STATUS = ARRAY.VAL<1>
    Y.CLOSE.LN.FLG = ARRAY.VAL<2>
    IF Y.LOAN.STATUS EQ "Write-off" THEN
        RETURN
    END

    GOSUB GET.COMMON.FIELDS
    GOSUB FETCH.COLLATERAL.ID
RETURN

FIND.COLL.VAL:
**************
    ERR.AA.ACTIVITY.HISTORY = ''; R.AA.ACTIVITY.HISTORY = ''; YACT.DTE.ID = ''; ID.COM3 = ''
    CALL F.READ(FN.AA.ACTIVITY.HISTORY,ARR.ID,R.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY,ERR.AA.ACTIVITY.HISTORY)
    IF R.AA.ACTIVITY.HISTORY THEN
        YACT.ID.ARR = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.REF> ;*Manual R22 conversion
    END

    YACT.DTE.ID = ''
    LOCATE "LENDING-TAKEOVER-ARRANGEMENT" IN YACT.ID.ARR<1,1> SETTING CHG.POSN.1 THEN
        YACT.DTE.ID = R.AA.ACTIVITY.HISTORY<AA.AH.ACT.DATE,CHG.POSN.1,1>
        TERM.AMT.ID = ARR.ID:'-COMMITMENT-':YACT.DTE.ID:'.1'
        GOSUB READ.TERM.AMT
    END

    YACT.DTE.ID = ''
    LOCATE "LENDING-NEW-ARRANGEMENT" IN YACT.ID.ARR<1,1> SETTING CHG.POSN.2 THEN
        YACT.DTE.ID = R.AA.ACTIVITY.HISTORY<AA.AH.ACT.DATE,CHG.POSN.2,1>
        TERM.AMT.ID = ARR.ID:'-COMMITMENT-':YACT.DTE.ID:'.1'
        GOSUB READ.TERM.AMT
    END
RETURN

READ.TERM.AMT:
**************
    AA.ARR.TERM.AMOUNT.ERR = ''; R.AA.ARR.TERM.AMOUNT = ''
    CALL F.READ(FN.AA.TERM.AMOUNT,TERM.AMT.ID,R.AA.TERM.AMOUNT,F.AA.TERM.AMOUNT,AA.ARR.TERM.AMOUNT.ERR)
RETURN

*-----------------
GET.COMMON.FIELDS:
*-----------------
    YACCT.GFLG = 0
    Y.LINKED.APPL    = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL>
    Y.LINKED.APPL.ID = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>

    LOCATE "ACCOUNT" IN Y.LINKED.APPL<1,1> SETTING Y.LINKED.POS THEN
        CHANGE @VM TO @FM IN Y.LINKED.APPL.ID
        Y.NROPRESTAMO  = Y.LINKED.APPL.ID<Y.LINKED.POS>
    END
    Y.ACCT.ID = Y.NROPRESTAMO
    ERR.ACCOUNT = ''; R.ACCOUNT = ''; Y.PREV.ACCOUNT = ''; Y.ALT.ACCT.TYPE= '';Y.ALT.ACCT.ID=''
    Y.ARRAY.VAL = ''; YCONT.DATE = ''; ERR.AA.ACCOUNT.DETAILS = ''; R.AA.ACCOUNT.DETAILS = ''
    CALL F.READ(FN.ACCOUNT,Y.ACCT.ID,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    IF ERR.ACCOUNT THEN
        YACCT.GFLG = 1
        RETURN
    END

    YACCT.GRP = R.ACCOUNT:"###":R.AA.ARRANGEMENT
    APAP.TAM.redoRptAcctAltLoans(YACCT.GRP,Y.PREV.ACCOUNT);*MANUAL R22 CODE CONVERSION
    IF NOT(Y.PREV.ACCOUNT) THEN
        Y.PREV.ACCOUNT = Y.NROPRESTAMO
        CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ARR.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ERR.AA.ACCOUNT.DETAILS)
        YCONT.DATE = R.AA.ACCOUNT.DETAILS<AA.AD.CONTRACT.DATE>
    END ELSE
        YCONT.DATE = R.AA.ARRANGEMENT<AA.ARR.ORIG.CONTRACT.DATE>
    END
    GOSUB GET.LN.CODE.5.1
    C$SPARE(451) = Y.PREV.ACCOUNT
    GOSUB GET.COMMON.FIELDS.1
RETURN
*---------------
GET.LN.CODE.5.1:
*---------------
**Verificar si tiene id alteno 4
    IF Y.NROPRESTAMO EQ Y.PREV.ACCOUNT THEN
        ID.ALTENO4 = '' ; Y.ALT.TYPE = ''
        Y.ALT.TYPE = R.ACCOUNT<AC.ALT.ACCT.TYPE>
        CHANGE @VM TO @FM IN Y.ALT.TYPE
        CHANGE @SM TO @FM IN Y.ALT.TYPE
        LOCATE "ALTERNO2" IN Y.ALT.TYPE<1> SETTING EYPO.POS THEN
            ID.ALTENO4  = R.ACCOUNT<AC.ALT.ACCT.ID,EYPO.POS,1>
            FINDSTR "VI" IN ID.ALTENO4 SETTING Ap, Vp THEN
                Y.PREV.ACCOUNT = ID.ALTENO4[3,LEN(ID.ALTENO4)]
            END
        END
    END
RETURN
GET.COMMON.FIELDS.1:
********************
* Get DEBTOR details
    Y.L.CU.DEBTOR.COM = ''
    LOCATE "PRODUCT.GROUP" IN Y.FIELD.NME.ARR<1,1> SETTING PRD.POS THEN
        Y.PRD.VAL.ARR = Y.FIELD.VAL.ARR<1,PRD.POS>
        Y.PRD.DIS.ARR = Y.DISP.TEXT.ARR<1,PRD.POS>
    END
    Y.PRD.VAL.ARR = CHANGE(Y.PRD.VAL.ARR,@SM,@VM)
    Y.PRD.DIS.ARR = CHANGE(Y.PRD.DIS.ARR,@SM,@VM)
    LOCATE Y.PROD.GUP IN Y.PRD.VAL.ARR<1,1> SETTING C.PRD.POS THEN
        Y.L.CU.DEBTOR.COM = Y.PRD.DIS.ARR<1,C.PRD.POS>
    END
    Y.DEBTOR.COMS = ''
RETURN

*----------------------
FETCH.COLLATERAL.ID:
*----------------------
* Fetch collateral Ids to process
    IF YACCT.GFLG EQ 1 THEN
        RETURN
    END
    CHANGE @SM TO @FM IN YL.AA.COL.VAL
    CHANGE @SM TO @FM IN COLLATERAL.ID
    LOOP
        REMOVE Y.COLLATERAL.ID FROM COLLATERAL.ID SETTING COLL.POS
    WHILE Y.COLLATERAL.ID:COLL.POS
        GOSUB PROCESSING.COLLAT
    REPEAT
RETURN

PROCESSING.COLLAT:
******************
    Y.CUSTOMER.ID = FIELD(Y.COLLATERAL.ID,".",1)
    CALL F.READ(FN.COLLATERAL,Y.COLLATERAL.ID,R.COLLATERAL,F.COLLATERAL,ERR.COLLATERAL)
    IF R.COLLATERAL THEN
        YCOLL.EXP.DTE = ''; Y.COLLATERAL.CODE = ''; C$SPARE(452) = ''; C$SPARE(453) = ''; C$SPARE(454) = ''; C$SPARE(455) = ''
        C$SPARE(456) = ''; C$SPARE(457) = ''; C$SPARE(458) = ''; C$SPARE(459) = ''; C$SPARE(460) = ''
        C$SPARE(461) = ''; C$SPARE(462) = ''; C$SPARE(463) = ''; C$SPARE(464) = ''; C$SPARE(465) = ''
        C$SPARE(466) = ''; C$SPARE(467) =''; C$SPARE(468) = ''; C$SPARE(469) = ''; C$SPARE(470) = ''
        C$SPARE(471) = ''; C$SPARE(472) = ''; C$SPARE(473) = ''; C$SPARE(474) = ''; C$SPARE(475) = ''
        C$SPARE(476) = ''; C$SPARE(477) = ''; C$SPARE(478) = ''; C$SPARE(479) = ''
        Y.COLLATERAL.CODE = R.COLLATERAL<COLL.COLLATERAL.CODE>
        YCOLL.EXP.DTE = R.COLLATERAL<COLL.EXPIRY.DATE>

*       IF YCOLL.EXP.DTE EQ '' OR YCOLL.EXP.DTE GE TODAY THEN
        GOSUB FETCH.FIELD.VALUES
        GOSUB MAP.RCL.VALUES
*      END
    END
RETURN

*------------------
FETCH.FIELD.VALUES:
*------------------
*--------------------------------------------------------------------
* Fetching the Collateral Description  C(15) and Guarantor Type  C(2)
*--------------------------------------------------------------------
    Y.GUAR.TYPE = ""; Y.COL.DESC = ''; YL.COL.GUAR.ID = ''
    Y.CUST.NAME = ''; Y.CUST.GN.NAME = ''
    Y.COL.DESC = R.COLLATERAL<COLL.LOCAL.REF,L.COL.SEC.IDEN.POS>
    YL.COL.GUAR.ID = R.COLLATERAL<COLL.LOCAL.REF,L.COL.GUAR.ID.POS>
*IF Y.COLLATERAL.CODE EQ "970" THEN
*        Y.GUAR.TYPE = R.COLLATERAL<COLL.LOCAL.REF,L.COL.GUAR.TYPE.POS>
*Y.COL.DESC = R.COLLATERAL<COLL.LOCAL.REF,L.COL.GUR.LEGID.POS>
*END
*---------------------------------------------------------------
    BEGIN CASE
        CASE (Y.COLLATERAL.CODE EQ '100' OR Y.COLLATERAL.CODE EQ '200')
            Y.COL.DESC = R.COLLATERAL<COLL.LOCAL.REF,L.COL.INVST.NO.POS>
        CASE Y.COLLATERAL.CODE EQ '150'
            Y.COL.DESC = R.COLLATERAL<COLL.LOCAL.REF,L.COL.NUM.INSTR.POS>
        CASE (Y.COLLATERAL.CODE EQ '350' OR Y.COLLATERAL.CODE '450')
            Y.COL.DESC = R.COLLATERAL<COLL.LOCAL.REF,L.COL.SEC.IDEN.POS>
        CASE Y.COLLATERAL.CODE EQ '970'
            Y.COL.DESC = R.COLLATERAL<COLL.LOCAL.REF,L.COL.GUR.LEGID.POS>
    END CASE
*------------------------------------------------------------------
    IF YL.COL.GUAR.ID THEN
        Y.PROD.GRP = ""; Y.REL.CODE = ""
        APAP.REDOSRTN.redoSRepCustomerExtract(YL.COL.GUAR.ID,Y.PROD.GRP,Y.REL.CODE,Y.OUT.ARR);*MANUAL R22 CODE CONVERSION
        Y.GUAR.TYPE = Y.OUT.ARR<2>
        Y.CUST.NAME = Y.OUT.ARR<3>
        Y.CUST.GN.NAME = Y.OUT.ARR<4>
    END


    C$SPARE(452) = Y.COL.DESC
    C$SPARE(453) = Y.GUAR.TYPE
*
*----------------------------------
* Fetching the Collateral Type  C(2)
*----------------------------------
    LOCATE Y.COLLATERAL.CODE IN Y.COLL.VAL.ARR<1,1> SETTING C.COLL.POS THEN
        C$SPARE(454) = Y.COLL.DIS.ARR<1,C.COLL.POS>
    END ELSE
        Y.COLLATERAL.TYPE = ''; Y.COLLATERAL.TYPE = R.COLLATERAL<COLL.COLLATERAL.TYPE>
        LOCATE Y.COLLATERAL.TYPE IN Y.COLL.VAL.ARR<1,1> SETTING C.COLL.POS THEN
            C$SPARE(454) = Y.COLL.DIS.ARR<1,C.COLL.POS>
        END
    END
    Y.COLLATERAL.TYPE = ''; Y.COLLATERAL.TYPE = R.COLLATERAL<COLL.COLLATERAL.TYPE>
    GOSUB FETCH.FIELD.VALUES.1
RETURN

FETCH.FIELD.VALUES.1:
*********************
*----------------------------------------------------------------------------------------------------------
* Fetching the Collateral Description  C(250), Constitution Date C(10), Date formalization Collateral C(10)
*----------------------------------------------------------------------------------------------------------
*
    Y.COL.ACT.DESC = ''; Y.COLLAT.DESC = ''; Y.COL.EXE.DATE = ''; Y.L.COL.GT.DATE = ''
    Y.L.COL.INVST.TYE = ''; Y.COLLATERAL.TYPE = ''
    Y.COLLAT.DESC = R.COLLATERAL<COLL.LOCAL.REF,L.COL.SEC.DESC.POS>
    Y.L.COL.INVST.TYE = R.COLLATERAL<COLL.LOCAL.REF,L.COL.INVST.TYE.POS>
    Y.COL.ACT.DESC = R.COLLATERAL<COLL.LOCAL.REF,L.COL.PRO.DESC2.POS>
    CHANGE @SM TO ' ' IN Y.COL.ACT.DESC

    IF NOT(Y.COL.ACT.DESC) AND Y.COLLATERAL.CODE NE '100' THEN
        Y.COLLATERAL.TYPE = R.COLLATERAL<COLL.COLLATERAL.TYPE>
        R.COLLATERAL.TYPE = ''; ERR.COLLATERAL.TYPE = ''
        CALL F.READ(FN.COLLATERAL.TYPE,Y.COLLATERAL.TYPE,R.COLLATERAL.TYPE,F.COLLATERAL.TYPE,ERR.COLLATERAL.TYPE)
        Y.COL.ACT.DESC = R.COLLATERAL.TYPE<COLL.TYPE.DESCRIPTION>
    END

    IF Y.COLLATERAL.CODE EQ '100' THEN
*Y.COL.ACT.DESC = Y.L.COL.INVST.TYE
        GOSUB FETCH.FIELD.VALUES.1.1
    END

    LOCATE Y.COLLATERAL.CODE IN Y.FETCH.VAL.ARR<1,1> SETTING C.FETC.POS THEN
        Y.IN.DATE = YCONT.DATE
        GOSUB DATE.CONV
        Y.COL.EXE.DATE = Y.OUT.DATE
        Y.L.COL.GT.DATE = Y.OUT.DATE
    END ELSE
        GOSUB GET.VAL.FLD7.8
    END

    Y.IN.DATE  = ""; Y.OUT.DATE = ""
*
    C$SPARE(455) = Y.COL.ACT.DESC
    C$SPARE(456) = Y.L.COL.GT.DATE
    C$SPARE(457) = Y.COL.EXE.DATE
    GOSUB FETCH.FIELD.VALUES.2
RETURN
FETCH.FIELD.VALUES.1.1:
**********************
    Y.EB.LOOK.ID = '' ; Y.EB.LOOK.ID = "L.CR.FACILITY*":Y.L.COL.INVST.TYE
    CALL F.READ(FN.EB.LOOKUP,Y.EB.LOOK.ID,R.EB.LOOKUP,F.EB.LOOKUP,EB.LOOKUP.ERR)
    Y.COL.ACT.DESC = R.EB.LOOKUP<EB.LU.DESCRIPTION,1>
RETURN
GET.VAL.FLD7.8:
***************
    Y.IN.DATE  = ""; Y.OUT.DATE = ""
    Y.COL.EXE.DATE = R.COLLATERAL<COLL.LOCAL.REF,L.COL.EXE.DATE.POS>
    Y.IN.DATE = Y.COL.EXE.DATE
    GOSUB DATE.CONV
    Y.COL.EXE.DATE = Y.OUT.DATE
*
    Y.IN.DATE  = ""; Y.OUT.DATE = ""
    Y.L.COL.GT.DATE = R.COLLATERAL<COLL.LOCAL.REF,L.COL.GT.DATE.POS>
    Y.IN.DATE = Y.L.COL.GT.DATE
    GOSUB DATE.CONV
    Y.L.COL.GT.DATE = Y.OUT.DATE
    Y.IN.DATE  = ""; Y.OUT.DATE = ""
RETURN

FETCH.FIELD.VALUES.2:
********************
*----------------------------------
* Fetching the Valuation Date C(10) / Valuation Amount N(15,2) / Encumbrance Grade N(1)
*----------------------------------
*
    Y.L.COL.VAL.DATE = ""; Y.L.COL.TOT.VALUA = ""; Y.ECN.NUMBER = ""
    LOCATE Y.COLLATERAL.CODE IN Y.VALUDTE.VAL.ARR<1,1> SETTING C.VALD.POS THEN
        Y.L.COL.VAL.DATE = R.COLLATERAL<COLL.LOCAL.REF,L.COL.VAL.DATE.POS>
        Y.IN.DATE  = ""; Y.OUT.DATE = ""
        Y.IN.DATE = Y.L.COL.VAL.DATE
        GOSUB DATE.CONV
        Y.L.COL.VAL.DATE = Y.OUT.DATE
        Y.IN.DATE  = ""; Y.OUT.DATE = ""
    END

    LOCATE Y.COLLATERAL.CODE IN Y.VALUAMT.VAL.ARR<1,1> SETTING C.VALA.POS THEN
        Y.L.COL.TOT.VALUA = R.COLLATERAL<COLL.NOMINAL.VALUE>
        Y.ECN.NUMBER = R.COLLATERAL<COLL.LOCAL.REF,L.ECN.NUMBER.POS>
    END
    IF Y.ECN.NUMBER EQ '' OR Y.ECN.NUMBER EQ 0 THEN
        Y.ECN.NUMBER = "1"
    END
    IF Y.COLLATERAL.CODE EQ "970" THEN
        Y.ECN.NUMBER = 0
    END

    C$SPARE(458) = Y.L.COL.VAL.DATE
    C$SPARE(459) = Y.L.COL.TOT.VALUA
    C$SPARE(460) = Y.ECN.NUMBER
    GOSUB FETCH.FIELD.VALUES.3
RETURN

FETCH.FIELD.VALUES.3:
*********************
*----------------------------------------
* Fetching the Title Collateral Type N(3)
*----------------------------------------
*LOCATE Y.COLLATERAL.CODE IN Y.COLLTYP.VAL.ARR<1,1> SETTING C.INV.POS THEN
*C$SPARE(461) = Y.L.COL.INVST.TYE
*END
    IF NOT(Y.L.COL.INVST.TYE) THEN
        GOSUB FETCH.FIELD.VALUES.3.1
        C$SPARE(461) = Y.FACILITY
    END ELSE
        C$SPARE(461) = Y.L.COL.INVST.TYE
    END
*----------------------------------------
* Fetching the Issuer Id C(15)
*----------------------------------------
    Y.COL.NAT.TAX = ""
    LOCATE Y.COLLATERAL.CODE IN Y.ISSID.VAL.ARR<1,1> SETTING C.ISSD.POS THEN
        Y.COL.NAT.TAX = R.COLLATERAL<COLL.LOCAL.REF,L.COL.NAT.TAX.POS>
    END
    IF Y.COL.NAT.TAX THEN
        GOSUB GET.CUST.DET
    END
    C$SPARE(462) = Y.COL.NAT.TAX
*
*----------------------------------------
* Fetching the Assured Collateral C(1)
*----------------------------------------
*
    Y.COL.INS.PLCY = ''
*    Y.COL.INS.PLCY = R.COLLATERAL<COLL.LOCAL.REF,L.COL.INS.PLCY.POS>
*    IF Y.COL.INS.PLCY THEN
*----Start---------Changed from "Y" to "S"---------28/10/2013--------**
*Y.L.COL.INS.PLCY = "Y"
*        Y.L.COL.INS.PLCY = "S"
*--------------Changed from "Y" to "S"---------28/10/2013--------**
*    END ELSE
*        Y.L.COL.INS.PLCY = "N"
*    END
*    C$SPARE(463) = Y.L.COL.INS.PLCY
*
    GOSUB FETCH.VALUES
RETURN

FETCH.FIELD.VALUES.3.1:
    Y.FACILITY = '' ; ARRANGEMENT.ID = Y.AA.ARR.ID
    R.AA.INTEREST  = ''
    PROP.CLASS     = 'ACCOUNT'
    PROP.NAME      = ''
    RET.ERR        = ''
    returnConditions = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ARRANGEMENT.ID,PROP.CLASS,PROP.NAME,'','',returnConditions,RET.ERR)
    R.AA.ACCOUNT.APP = RAISE(returnConditions)
    ACCOUNT.APP = R.AA.ACCOUNT.APP
    Y.FACILITY =   ACCOUNT.APP<AA.AC.LOCAL.REF,Y.L.CR.FACILITY.POS>
RETURN


GET.CUST.DET:
*************
    ERR.CUSTOMER.L.CU.CIDENT = ''; R.CUSTOMER.L.CU.CIDENT = ''
    CALL F.READ(FN.CUSTOMER.L.CU.CIDENT,Y.COL.NAT.TAX,R.CUSTOMER.L.CU.CIDENT,F.CUSTOMER.L.CU.CIDENT,ERR.CUSTOMER.L.CU.CIDENT)
    IF R.CUSTOMER.L.CU.CIDENT THEN
        Y.COL.NAT.TAX = FMT(Y.COL.NAT.TAX, "R(###-#######-#)")
        RETURN
    END
    IF LEN(Y.COL.NAT.TAX) EQ 11 THEN
        Y.COL.NAT.TAX = FMT(Y.COL.NAT.TAX, "R(###-#######-#)")
        RETURN
    END
    ERR.CUSTOMER.L.CU.RNC = ''; R.CUSTOMER.L.CU.RNC = ''
    CALL F.READ(FN.CUSTOMER.L.CU.RNC,Y.COL.NAT.TAX,R.CUSTOMER.L.CU.RNC,F.CUSTOMER.L.CU.RNC,ERR.CUSTOMER.L.CU.RNC)
    IF R.CUSTOMER.L.CU.RNC THEN
        Y.COL.NAT.TAX = FMT(Y.COL.NAT.TAX, "R(#-##-#####-#)")
        RETURN
    END
    IF LEN(Y.COL.NAT.TAX) EQ 9 THEN
        Y.COL.NAT.TAX = FMT(Y.COL.NAT.TAX, "R(#-##-#####-#)")
    END
RETURN

*------------
FETCH.VALUES:
*------------
*-----------------------------------------------
* Fetching the Insurance Expiry Date C(10)
*-----------------------------------------------
    Y.COL.POL.DATE = ""; R.APAP.H.INSURANCE.ID.CONCAT =''; ERR.AHIC = ''; INSUR.REC = ''; INSUR.REC.CNT = 0; YGRP.CNT = 0
    INSUR.TPE = ''; YINS.POLCY.NO = ''; YINS.POLCY = ''; Y.COL.POL.DTE = ''; Y.COL.POL.DATE = ''; Y.IN.DATE = ''
    Y.POLICY.ORG.DATE = ''; Y.INS.DET.INS.AMOUNT = ''; Y.POLIZA.PADRE = ''; Y.COMPANY.POLIZA = ''
    CALL F.READ(FN.APAP.H.INSURANCE.ID.CONCAT,Y.AA.ARR.ID,R.APAP.H.INSURANCE.ID.CONCAT,F.APAP.H.INSURANCE.ID.CONCAT,ERR.AHIIC)
    IF R.APAP.H.INSURANCE.ID.CONCAT THEN
        INSUR.REC = R.APAP.H.INSURANCE.ID.CONCAT<1>
        INSUR.TPE = R.APAP.H.INSURANCE.ID.CONCAT<2>
        INSUR.REC.CNT = DCOUNT(INSUR.REC,@VM)
        LOOP
        UNTIL INSUR.REC.CNT EQ 0
            ERR.APAP.H.INSURANCE.DETAILS = ''; R.APAP.H.INSURANCE.DETAILS = ''; YINS.POLCY.NO = ''
            INSUR.REC.ID = ''; YINS.POLCY = ''; Y.COL.POL.DATE = ''; YINS.POLCYSTAT = ''
            INSUR.REC.ID = INSUR.REC<1,INSUR.REC.CNT>
            INSUR.TPE.ID = INSUR.TPE<1,INSUR.REC.CNT>
            LOCATE INSUR.TPE.ID IN Y.INSP.VAL.ARR<1,1> SETTING C.INSR.POS ELSE
                INSUR.REC.CNT -= 1
                CONTINUE
            END

            CALL F.READ(FN.APAP.H.INSURANCE.DETAILS,INSUR.REC.ID,R.APAP.H.INSURANCE.DETAILS,F.APAP.H.INSURANCE.DETAILS,ERR.APAP.H.INSURANCE.DETAILS)
            Y.COL.POL.DATE = R.APAP.H.INSURANCE.DETAILS<INS.DET.POL.EXP.DATE>
            YINS.POLCY = R.APAP.H.INSURANCE.DETAILS<INS.DET.POLICY.NUMBER>
            YINS.POLCYSTAT = R.APAP.H.INSURANCE.DETAILS<INS.DET.POLICY.STATUS>
            IF Y.COL.POL.DATE AND Y.COL.POL.DATE GT Y.TODATE AND YINS.POLCYSTAT EQ 'VIGENTE' THEN
                YINS.POLCY.NO = "S"
                Y.IN.DATE = Y.COL.POL.DATE
                INSUR.REC.CNT = 0
*-------------------------------------------------------------------------------
                Y.POLICY.ORG.DATE = R.APAP.H.INSURANCE.DETAILS<INS.DET.POLICY.ORG.DATE>
                Y.INS.DET.INS.AMOUNT = R.APAP.H.INSURANCE.DETAILS<INS.DET.INS.AMOUNT>
                Y.POLIZA.PADRE = R.APAP.H.INSURANCE.DETAILS<INS.DET.SEN.POLICY.NUMBER>
                Y.COMPANY.POLIZA = R.APAP.H.INSURANCE.DETAILS<INS.DET.INS.COMPANY>
                IF NOT(Y.POLIZA.PADRE) THEN
                    Y.POLIZA.PADRE = YINS.POLCY
                END
*-------------------------------------------------------------------------------
                CONTINUE
            END
            INSUR.REC.CNT -= 1
        REPEAT
    END
    IF Y.IN.DATE THEN
        GOSUB DATE.CONV
        Y.COL.POL.DATE = Y.OUT.DATE
        Y.IN.DATE  = ""; Y.OUT.DATE = ""
    END

    R.CUSTOMER = ''; ERR.CUSTOMER = ''
    CALL F.READ(FN.CUSTOMER,YAA.CUSTOMER,R.CUSTOMER,F.CUSTOMER,ERR.CUSTOMER)
    YNAME.CUST = R.CUSTOMER<EB.CUS.NAME.1>
    IF NOT(YNAME.CUST) THEN
        YNAME.CUST = R.CUSTOMER<EB.CUS.TEXT>
    END

    C$SPARE(463) = YINS.POLCY.NO
    IF NOT(YINS.POLCY.NO) THEN
        C$SPARE(463) = "N"
        Y.COL.POL.DATE = ''
    END
*    IF Y.COL.INS.PLCY THEN
*        Y.COL.POL.DATE = R.COLLATERAL<COLL.LOCAL.REF,L.COL.POL.DATE.POS>
*    END
    C$SPARE(464) = Y.COL.POL.DATE
*
    IF YINS.POLCY NE '' THEN
        L.APAP.POLIZA.ID = YINS.POLCY
    END
*-------------------------------------------------------------------------------
    LOCATE Y.COLLATERAL.CODE IN Y.ISSID.VAL.ARR<1,1> SETTING C.ISSD.POS THEN
        Y.CUST.NAME = R.COLLATERAL<COLL.LOCAL.REF,L.COL.ENTY.INS.POS>
        Y.CUST.GN.NAME = R.COLLATERAL<COLL.LOCAL.REF,L.COL.ENTY.INS.POS>
    END
    IF Y.COLLATERAL.CODE EQ '970' THEN
        Y.CUST.NAME = R.COLLATERAL<COLL.LOCAL.REF,L.COL.GUAR.NAME.POS>
        Y.CUST.GN.NAME = R.COLLATERAL<COLL.LOCAL.REF,L.COL.DEBTOR.NA.POS>
    END
*-------------------------------------------------------------------------------------

    C$SPARE(465) = Y.CUST.NAME
*
*------------------------------------------
* Fetching the Customer SurName C(30)
*------------------------------------------
*
    C$SPARE(466) = Y.CUST.GN.NAME
*
*------------------------------------------
* Fetching the  Credit Type C(1)
*------------------------------------------
*
    Y.L.AA.MMD.PYME = ''; Y.L.CU.DEBTOR = ''; YL.CU.DEBTOR= ''
    Y.L.AA.MMD.PYME = R.CUSTOMER<EB.CUS.LOCAL.REF,L.AA.MMD.PYME.POS>
    YL.CU.DEBTOR = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.DEBTOR.POS>
    IF Y.PROD.GUP EQ "COMERCIAL" THEN
        Y.L.CU.DEBTOR = YL.CU.DEBTOR
    END ELSE
        Y.L.CU.DEBTOR = Y.L.CU.DEBTOR.COM
    END

    IF Y.PROD.GUP EQ "LINEAS.DE.CREDITO" THEN
        FINDSTR "COM" IN Y.AA.PROD SETTING YFM,YSM,YVM THEN
            Y.L.CU.DEBTOR = YL.CU.DEBTOR
        END ELSE
            Y.L.CU.DEBTOR = Y.PRDSB.DIS.ARR<1,1>
        END
    END

    C$SPARE(467) = Y.L.CU.DEBTOR
*-------------------------------------------------------
* Fetching the Title Customer Admissible Collateral C(19)
*-------------------------------------------------------
*
    Y.CENT.BANK.VALUE = ""
    Y.CENT.BANK.VALUE = R.COLLATERAL<COLL.CENTRAL.BANK.VALUE>
*------------------------------------------------------------------------------------------------------------------------
    IF NOT(YINS.POLCY.NO) AND (Y.COLLATERAL.TYPE NE '457' AND Y.COLLATERAL.TYPE  NE '451' AND Y.COLLATERAL.TYPE NE '455') THEN
        Y.CENT.BANK.VALUE = 0
    END
*--------------------------------------------------------------------------------------------------------------------------
    C$SPARE(468) = Y.CENT.BANK.VALUE
*
*---------------------------------------------------------
* Fetching the Title Building Year / Construction Year C(4)
*---------------------------------------------------------
*
    BULD.YR = ''
    Y.L.COL.YR.BLDING = R.COLLATERAL<COLL.LOCAL.REF,L.COL.YR.BLDING.POS>

    IF Y.COLLATERAL.CODE EQ "350" THEN
        BULD.YR = Y.COLLAT.DESC
    END

    IF NOT(Y.COLLAT.DESC) AND Y.L.COL.YR.BLDING THEN
        Y.TODAY = TODAY
        Y.TODAY.YR = TODAY[1,4]
        BULD.YR = SSUB(Y.TODAY.YR,Y.L.COL.YR.BLDING)
    END
    C$SPARE(469) = BULD.YR
    GOSUB FETCH.FIELD.VALUES.4
RETURN
*
*-------------------------------------------------
MAP.RCL.VALUES:
*------------------------------------------------
* Pass arguments to RCL and get the return message

    IF (YACCT.MONTO EQ 0 OR YACCT.MONTO EQ '') AND Y.CLOSE.LN.FLG EQ 1 THEN
        RETURN
    END
    IF YFIN.TOT EQ 0 THEN
        RETURN
    END

    Y.AA.ID = ''; Y.AA.ID = Y.AA.ARR.ID:'_':Y.COLLATERAL.ID
    R.RETURN.MSG = ""
    RCL.ID  = Y.RCL.ID
    MAP.FMT = "MAP"
    APP     = FN.AA.ARRANGEMENT
    R.APP   = R.AA.ARRANGEMENT
    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,RCL.ID,APP,Y.AA.ARR.ID,R.APP,R.RETURN.MSG,ERR.MSG)
    CALL F.WRITE(FN.DR.REG.DE03.WORKFILE,Y.AA.ID,R.RETURN.MSG)
RETURN

*---------
DATE.CONV:
*---------
    IF Y.IN.DATE THEN
        Y.DATE.YY = Y.IN.DATE[1,4]
        Y.DATE.MM = Y.IN.DATE[5,2]
        Y.DATE.DT = Y.IN.DATE[7,2]
        Y.OUT.DATE = Y.DATE.DT:"/":Y.DATE.MM:"/":Y.DATE.YY
    END
RETURN
*-----------
FETCH.FIELD.VALUES.4:
*--------------------------
*Calculando el monto de porrateo
*---------------------------
    Y.L.AC.LK.COL.ID.TYPE = ''; Y.CAPITAL.PENDIENTE = 0; Y.MONTO.TOTAL = 0;
    Y.DEUDA_TOTAL_DE_PRESTAMO = 0; Y.PORCENTAJE = 0; Y.MONTO_PORRATEO_GARANTIA = 0
    Y.GARANTIA.ADMISIBLE = 0
    Y.L.AC.LK.COL.ID.TYPE = R.COLLATERAL<COLL.LOCAL.REF,L.AC.LK.COL.ID.POS>
    Y.GARANTIA.ADMISIBLE = R.COLLATERAL<COLL.CENTRAL.BANK.VALUE>
    Y.CNT = DCOUNT(Y.L.AC.LK.COL.ID.TYPE,@VM)

    FOR I.VAR = 1 TO Y.CNT
        Y.L.AC.LK.COL.ID.POS = R.COLLATERAL<COLL.LOCAL.REF,L.AC.LK.COL.ID.POS,I.VAR>
        APAP.LAPAP.lApapReturnBanlaceCancelacion(Y.L.AC.LK.COL.ID.POS,OUT.RECORD) ;*Manual R22 conversion
        Y.CAPITAL.PENDIENTE = FIELD(OUT.RECORD,"*",1)
        Y.MONTO.TOTAL += Y.CAPITAL.PENDIENTE
        Y.DEUDA_TOTAL_DE_PRESTAMO = Y.MONTO.TOTAL
    NEXT I.VAR
    APAP.LAPAP.lApapReturnBanlaceCancelacion(Y.AA.ARR.ID,OUT.RECORD) ;*Manual R22 conversion
    Y.DEUDA_TOTAL_POR_PRESTAMO  = FIELD(OUT.RECORD,"*",1)
    YACCT.MONTO = 0; YACCT.MONTO = FIELD(OUT.RECORD,"*",2)
    YPRACCT.MONTO = 0; YPRACCT.MONTO = FIELD(OUT.RECORD,"*",4)
    YFIN.TOT = 0; YFIN.TOT = YPRACCT.MONTO + YACCT.MONTO
    Y.PORCENTAJE = Y.DEUDA_TOTAL_POR_PRESTAMO / Y.DEUDA_TOTAL_DE_PRESTAMO
    Y.MONTO_PORRATEO_GARANTIA = Y.GARANTIA.ADMISIBLE * Y.PORCENTAJE
    Y.NUMERO = ISDIGIT(Y.MONTO_PORRATEO_GARANTIA)
    IF Y.NUMERO EQ 0 THEN
        Y.MONTO_PORRATEO_GARANTIA = 0
    END
    C$SPARE(470) = Y.MONTO_PORRATEO_GARANTIA
*--------------------------------------------------------
*Identificacion del tasador que realizo ultima tasacion
*--------------------------------------------------------
    Y.L.COL.VALU.NAM = ''
    Y.L.COL.VALU.NAM = R.COLLATERAL<COLL.LOCAL.REF,Y.VALU.NAM.POS>
*--------------------------------------
*Fecha de vencimiento de la garant
*--------------------------------------
    Y.MATURY.DATE = ''
*----------------------------------------------------------------------
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ARR.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ERR.AA.ACCOUNT.DETAILS)
    Y.MATURY.DATE = R.AA.ACCOUNT.DETAILS<AA.AD.MATURITY.DATE>
    Y.IN.DATE = Y.MATURY.DATE
    GOSUB DATE.CONV
    Y.MATURY.DATE = Y.OUT.DATE
    Y.IN.DATE  = ""; Y.OUT.DATE = ""
*--------------------------------------------------------
    IF Y.L.COL.VALU.NAM THEN
        Y.COL.NAT.TAX.TP = ''; Y.COL.NAT.TAX.TP = Y.COL.NAT.TAX
        Y.COL.NAT.TAX = Y.L.COL.VALU.NAM
        GOSUB GET.CUST.DET
        Y.L.COL.VALU.NAM = Y.COL.NAT.TAX
        Y.COL.NAT.TAX = Y.COL.NAT.TAX.TP
    END
    C$SPARE(471) = Y.L.COL.VALU.NAM
    C$SPARE(472) = Y.MATURY.DATE
    GOSUB FETCH.FIELD.VALUES.5
RETURN
*-------------------------
*-------------------------
FETCH.FIELD.VALUES.5:
*------------------------
*-------------------------------------------------------
*--------------DATOS DE LA POLIZA-----------------------
*--------Numero de la poa de seguro
*--------Fecha de Emision de la poliza de seguro
*--------Identificacioe la Compania aseguradora
*--------Valor del Endoso
*-------------------------------------------------------
    R.POLIZA = ""; R.ERROR = "" ; Y.RNC.SEGURO = ''
    CALL F.READ(FN.POLIZA,Y.COMPANY.POLIZA,R.POLIZA,FV.POLIZA,R.ERROR)
    Y.RNC.SEGURO = R.POLIZA<2>
    IF Y.RNC.SEGURO NE '' THEN
        Y.RNC.SEGURO = FMT(Y.RNC.SEGURO, "R(#-##-#####-#)")
    END
    LONGITUD = 0
    LONGITUD = LEN(Y.POLIZA.PADRE)
    IF LONGITUD GT 10 THEN
        Y.POLIZA.PADRE = TRIM(Y.POLIZA.PADRE,"","A")
        Y.POLIZA.PADRE  = CHANGE(Y.POLIZA.PADRE,"/","")
        Y.POLIZA.PADRE = CHANGE(Y.POLIZA.PADRE,"-","")
        Y.POLIZA.PADRE = Y.POLIZA.PADRE[1,10]
    END
*---------------------------------------------
    Y.IN.DATE = Y.POLICY.ORG.DATE
    GOSUB DATE.CONV
    Y.POLICY.ORG.DATE = Y.OUT.DATE
    Y.IN.DATE = ""; Y.OUT.DATE = ""
*-------------------------------------------------
    IF NOT(YINS.POLCY.NO) THEN
        Y.POLIZA.PADRE = '' ; Y.POLICY.ORG.DATE = ''
        Y.RNC.SEGURO = ''; Y.INS.DET.INS.AMOUNT = 0
    END
    C$SPARE(473) = Y.POLIZA.PADRE
    C$SPARE(474) = Y.POLICY.ORG.DATE
    C$SPARE(475) = Y.RNC.SEGURO
    C$SPARE(476) = Y.INS.DET.INS.AMOUNT
    GOSUB FETCH.FIELD.VALUES.6
*------------------------------------------------
RETURN
*------------------------------------------------
FETCH.FIELD.VALUES.6:
*------------------------------------------------
*-------------------------------------------------------
*-------------DATOS DE LA GARANTIA FIDUCIARIA--------------
*-------------Garantia Fiduciaria
*-------------Clasificacion de fideicomisos de fuente de pago
*-------------Descripcio de fideicomisos de fuente de pago
*-------------------------------------------------------
    Y.L.APAP.GRTA.FID = ''; Y.L.APAP.CLA.FIDE = ''; Y.L.APAP.DES.FIDE = ''
    Y.L.APAP.GRTA.FID = R.COLLATERAL<COLL.LOCAL.REF,Y.GRTA.FID.POS>
    Y.L.APAP.CLA.FIDE = R.COLLATERAL<COLL.LOCAL.REF,Y.CLA.FIDE.POS>
    Y.L.APAP.DES.FIDE = R.COLLATERAL<COLL.LOCAL.REF,Y.DES.FIDE.POS>
    IF Y.L.APAP.GRTA.FID EQ '' AND YNAME.CUST[1,8] EQ 'FIDEICOM' THEN
        Y.L.APAP.GRTA.FID = "S"
    END
    C$SPARE(477) = Y.L.APAP.GRTA.FID
    C$SPARE(478) = Y.L.APAP.CLA.FIDE
    C$SPARE(479) = Y.L.APAP.DES.FIDE
RETURN
END

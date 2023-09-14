* @ValidationCode : MjoyMDk0NTY2ODc0OkNwMTI1MjoxNjgwNzc2MDcwODQ3OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:44:30
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.DISB.CHAR(DATA.OUT)
*********************************************************************
*Company Name  : APAP
*First Release : Meza William
*Developed for : APAP
*Developed by  : RTAM/Meza William
*Date          : Sep/09/11
*--------------------------------------------------------------------------------------------
* Subroutine Type       : NOFILE
* Attached to           : ENQUIRY - REDO.DISB.CHAR
* Attached as           :
* Primary Purpose       : NoFile Enquiry para mostrar los desembolsos(FT's) y los cargos asociados a un AA
*--------------------------------------------------------------------------------------------
* Modification Details:
*--------------------------------------------------------------------------------------------
* 01/01/1900 - ODR-1900- XX-XXXX
*
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*06/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION            F.READ TO CACHE.READ, FM TO @FM, VM TO @VM
*06/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*************************************************************************
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
*
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.USER
*
    $INSERT I_F.AA.PROPERTY
*
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.FC.FORM.DISB
*
*************************************************************************
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ======
PROCESS:
* ======
*
    DATA.OUT       = ""
    DATA.EACH.PLAN = ""
    NOMBRE.CLIENTE = ""
*
    ID.CLIENTE = R.REDO.CREATE.ARRANGEMENT<REDO.FC.CUSTOMER>
    GOSUB GET.CONTRACT.DATA
*
    W.NRO.TIP.DESEM = DCOUNT(R.REDO.CREATE.ARRANGEMENT<REDO.FC.DIS.TYPE>,@VM)      ;*NRO TIPOS DE DESEMBOLSO
    W.CARGO.DESEM   = DCOUNT(R.REDO.CREATE.ARRANGEMENT<REDO.FC.CHARG.DISC>,@VM)    ;*NRO CARGOS DE DESEMBOLSO
*
* COLLECT DISBURSEMENT INSTRUCTION INFORMATION
*
    LOOP.CNT.INS = 1
    LOOP WHILE LOOP.CNT.INS LE W.NRO.TIP.DESEM AND PROCESS.GOAHEAD
        DATA.EACH.PLAN     = ""
        GOSUB GET.DESC.TIPO.DESEM
        DATA.EACH.PLAN<-1> = DESC.TIPO.DESEM          ;*TIPO DESEMBOLSO
        DATA.EACH.PLAN<-1> = R.REDO.CREATE.ARRANGEMENT<REDO.FC.DIS.AMT, LOOP.CNT.INS>         ;*MONTO DESEMBOLSO DE LA TRANX
        DATA.EACH.PLAN<-1> = R.REDO.CREATE.ARRANGEMENT<REDO.FC.DIS.CODTXN, LOOP.CNT.INS>      ;*FT ID TRANSACTION
        DATA.EACH.PLAN<-1> = R.REDO.CREATE.ARRANGEMENT<REDO.FC.DIS.STA, LOOP.CNT.INS>         ;*FT ID TRANSACTION
        DATA.EACH.PLAN<-1> = CONTRACT.DATA
        CHANGE @FM TO "*" IN DATA.EACH.PLAN
        DATA.OUT<-1> = DATA.EACH.PLAN
        LOOP.CNT.INS += 1
    REPEAT
*
* COLLECT CHARGES AND EXPENSES INFORMATION
*
    LOOP.CNT = 1
    LOOP WHILE LOOP.CNT LE W.CARGO.DESEM AND PROCESS.GOAHEAD
        DATA.EACH.PLAN     = ""
        GOSUB GET.DESC.TRAN
        DATA.EACH.PLAN<-1> = DES.TRAN       ;*DESCRIPCION DE LA TRANSACCION CARGOS
        DATA.EACH.PLAN<-1> = R.REDO.CREATE.ARRANGEMENT<REDO.FC.CHARG.AMOUNT,LOOP.CNT>         ;*MONTO TRX DE CARGO
        DATA.EACH.PLAN<-1> = ""
        DATA.EACH.PLAN<-1> = CONTRACT.DATA
        CHANGE @FM TO "*" IN DATA.EACH.PLAN
        DATA.OUT<-1> = DATA.EACH.PLAN
        LOOP.CNT += 1
    REPEAT
*
    IF DATA.OUT EQ "" THEN
        DATA.OUT<-1> ="NO EXISTEN DESEMBOLSOS PARA EL ": WTIPO.FILT : WCONT.DATA
    END
*
RETURN
*
* ================
GET.CONTRACT.DATA:
* ================
*
    CONTRACT.DATA  = ""
*
    CALL F.READ(FN.CUSTOMER,ID.CLIENTE,R.CUSTOMER,F.CUSTOMER,ERR.CUS)
    NOMBRE.CLIENTE = "  " : R.CUSTOMER<EB.CUS.SHORT.NAME>
*
    CONTRACT.DATA<-1> = R.REDO.CREATE.ARRANGEMENT<REDO.FC.ID.ARRANGEMENT>         ;*ARRANGEMENT.ID
    CONTRACT.DATA<-1> = R.REDO.CREATE.ARRANGEMENT<REDO.FC.CUSTOMER> : NOMBRE.CLIENTE        ;*ID CLIENTE + NOMBRE DEL CLIENTE
    CONTRACT.DATA<-1> = R.REDO.CREATE.ARRANGEMENT<REDO.FC.LOAN.CURRENCY>          ;*MONEDA DEL DESEMBOLSO
    CONTRACT.DATA<-1> = R.REDO.CREATE.ARRANGEMENT<REDO.FC.DIS.AMT.TOT>  ;*MONTO TOTAL DEL DESEMBOLSO
    CHANGE @FM TO "*" IN CONTRACT.DATA
*
RETURN
*
* ============
GET.DESC.TRAN:
* ============
*
    COD.TRAN = R.REDO.CREATE.ARRANGEMENT<REDO.FC.CHARG.DISC,LOOP.CNT>
    CALL CACHE.READ(FN.PROPERTY, COD.TRAN, R.PROPERTY, ERR.PROP) ;*AUTO R22 CODE CONVERSION
    DES.TRAN = R.PROPERTY<AA.PROP.DESCRIPTION,WLANG>
*
RETURN
*
* ==================
GET.DESC.TIPO.DESEM:
* ==================
*
    COD.TIPO.DESEM = R.REDO.CREATE.ARRANGEMENT<REDO.FC.DIS.TYPE, LOOP.CNT.INS>
    CALL F.READ(FN.REDO.FC.FORM.DISB, COD.TIPO.DESEM, R.REDO.FC.FORM.DISB, F.REDO.FC.FORM.DISB, ERR.REDO.FC.FORM.DISB)
    DESC.TIPO.DESEM = R.REDO.FC.FORM.DISB<FC.PR.DESCRIPCION>
*
RETURN
*
* =========
FIND.AA.ID:
* =========
*
    CALL F.READ(FN.ACCOUNT,WCONT.DATA,R.ACCOUNT,F.ACCOUNT,ERR.ACC)
    IF R.ACCOUNT THEN
        WCONT.DATA      = R.ACCOUNT<AC.ARRANGEMENT.ID>
        SEL.CMD.MM      = 'SELECT ' : FN.REDO.CREATE.ARRANGEMENT : ' WITH ID.ARRANGEMENT EQ ' : WCONT.DATA
    END ELSE
        PROCESS.GOAHEAD = ""
    END
*
RETURN
*
* ===========
ANALYSE.DATA:
* ===========
*
    IF WCONT.DATA[1,2] NE "AA" THEN
        GOSUB FIND.AA.ID
    END ELSE
        SEL.CMD.MM = 'SELECT ' : FN.REDO.CREATE.ARRANGEMENT : ' WITH ID.ARRANGEMENT EQ ' : WCONT.DATA
    END
*
RETURN
*
* =============
ANALYZE.FILTER:
* =============
*
    FILTER.CNT      = 1
    FILTER.LOOPS    = 2
*
    LOOP WHILE FILTER.CNT LE FILTER.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE FILTER.CNT EQ 1
                LOCATE "CONT.DATA" IN D.FIELDS<1>SETTING CONT.POS THEN
                    WTIPO.FILT = " CONTRATO *"
                    WCONT.DATA = D.RANGE.AND.VALUE<CONT.POS>
                    GOSUB ANALYSE.DATA
                END

            CASE FILTER.CNT EQ 2
                LOCATE "CUS.DATA" IN D.FIELDS<1>SETTING CUS.POS THEN
                    WCUS.ID    = D.RANGE.AND.VALUE<CUS.POS>
                    WTIPO.FILT = " CLIENTE *"
                    SEL.CMD.MM = 'SELECT ' : FN.REDO.CREATE.ARRANGEMENT : ' WITH CUSTOMER EQ ' : WCUS.ID
                    WCONT.DATA = WCUS.ID
                END ELSE
                    PROCESS.GOAHEAD = ""
                END
        END CASE
*
        FILTER.CNT += 1
*
    REPEAT
*
RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD = 1
*
    SEL.LIST.MM = ''
    SEL.CMD.MM  = ''
    NO.OF.REC   = 0
    RET.CODE    = 0
    RCA.ID      = ''
*
    WLANG = R.USER<EB.USE.LANGUAGE>       ;*OBTENGO EL LENGUAJE DE LA SESION PARA DE ACUERDO A ÉSTE PRESENTAR LOS MENSAJES DE PROPERTY
*
    FN.REDO.CREATE.ARRANGEMENT = "F.REDO.CREATE.ARRANGEMENT"
    F.REDO.CREATE.ARRANGEMENT  = ""
*
    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER  = ""
*
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ""
*
    FN.PROPERTY = "F.AA.PROPERTY"
    F.PROPERTY  = ""
*
    FN.REDO.FC.FORM.DISB = "F.REDO.FC.FORM.DISB"
    F.REDO.FC.FORM.DISB  = ""
*
RETURN
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.REDO.CREATE.ARRANGEMENT, F.REDO.CREATE.ARRANGEMENT)
*
RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP.CNT=1
    MAX.LOOPS = 3

    LOOP WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                GOSUB ANALYZE.FILTER

            CASE LOOP.CNT EQ 2
                CALL EB.READLIST(SEL.CMD.MM, LIST.IDS, '', NO.OF.REC, RET.CODE)
                IF NO.OF.REC EQ 0 THEN
                    DATA.OUT<-1>    = "NO EXISTEN DESEMBOLSOS PARA EL ": WTIPO.FILT : WCONT.DATA
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 3
                REMOVE RCA.ID FROM LIST.IDS SETTING POS.MM  ;*DEBE EXISTIR UN SOLO RCA PARA EL AA PROPORCIONADO POR EL USUARIO
                CALL F.READ(FN.REDO.CREATE.ARRANGEMENT,RCA.ID,R.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT,ERR.MSJ)
                IF ERR.MSJ THEN
                    DATA.OUT<-1>    = "NO EXISTEN DESEMBOLSOS PARA EL REGISTRO RCA*" : RCA.ID
                    PROCESS.GOAHEAD = ""
                END

        END CASE
*
        LOOP.CNT += 1
*
    REPEAT
*
RETURN
*
END

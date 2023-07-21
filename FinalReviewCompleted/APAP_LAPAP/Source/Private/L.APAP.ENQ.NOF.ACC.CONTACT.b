* @ValidationCode : MjotMTY4NjM4ODA2OkNwMTI1MjoxNjg5MjQzMjcyODI4OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jul 2023 15:44:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* @(#) L.APAP.ENQ.NOF.ACC.CONTACT Ported to jBASE 16:16:58  28 NOV 2017
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.ENQ.NOF.ACC.CONTACT(Y.FINAL)
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       BP Removed, F.READ to CACHE.READ, J to J.VAR, ++ to +=, < to LT, CONVERT to CHANGE
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON                              ;*R22 Auto conversion - Start
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CATEGORY
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.REDO.CUST.PRD.LIST
    $INSERT I_F.APAP.PARAM.DB.CR.MASK              ;*R22 Auto conversion - End

**----------------------------------------
**ABRIR LA TABLA FBNK.REDO.CUST.PRD.LIST
**----------------------------------------
    FN.CUS.PRD = "F.REDO.CUST.PRD.LIST"
    FV.CUS.PRD = ""
    R.CUS.PRD = ""
    CUS.PRD.ERR = ""

**---------------------------------------
**ABRIR LA TABLA CUSTOMER
**---------------------------------------
    FN.CUS = "F.CUSTOMER"
    FV.CUS = ""
    R.CUS = ""
    CUS.ERR = ""
    CALL OPF(FN.CUS,FV.CUS)

**---------------------------------------
**ABRIR LA TABLA F.ACCOUNT Y F.ACCOUNT.CLOSED
**---------------------------------------
    FN.ACC = "F.ACCOUNT"
    FV.ACC = ""
    R.ACC = ""
    ACC.ERR = ""

    FN.ACC.C = "F.ACCOUNT.CLOSED"
    FV.ACC.C = ""
    R.ACC.C = ""
    ACC.ERR.C = ""
    CALL OPF(FN.ACC.C,FV.ACC.C)

**---------------------------------------
**ABRIR LA TABLA CATEGORY
**---------------------------------------
    FN.CAT = "F.CATEGORY"
    FV.CAT = ""
    R.CAT = ""
    CAT.ERR = ""
    CALL OPF(FN.CAT,FV.CAT)

**---------------------------------------
**ABRIR LA TABLA AZ.ACCOUNT
**---------------------------------------
    FN.AZ.ACC = "F.AZ.ACCOUNT"
    FV.AZ.ACC = ""
    R.AZ.ACC = ""
    AZ.ACC.ERR = ""
    CALL OPF(FN.AZ.ACC,FV.AZ.ACC)

**---------------------------------------
**TABLA FBNK.JOINT.CONTRACTS.XREF
**---------------------------------------
    FN.JOINT.CONTRACTS.XREF='F.JOINT.CONTRACTS.XREF';
    FV.JOINT.CONTRACTS.XREF=''
    R.JOINT.CONTRACTS.XREF = ""
    JOINT.CONTRACTS.XREF.ERR = ""
    CALL OPF(FN.JOINT.CONTRACTS.XREF,FV.JOINT.CONTRACTS.XREF)

    FN.APAP.PARAM.DB.CR.MASK = "F.APAP.PARAM.DB.CR.MASK"
    F.APAP.PARAM.DB.CR.MASK = ""
    CALL OPF(FN.APAP.PARAM.DB.CR.MASK,F.APAP.PARAM.DB.CR.MASK)


**---------------------------------------------------------------------------------------------
**SENTENCIA LOCATE
**---------------------------------------------------------------------------------------------
    LOCATE "CUSTOMER.NUMBER" IN D.FIELDS<1> SETTING CUS.POS THEN
        F.ID = D.RANGE.AND.VALUE<CUS.POS>
    END

**------------------------------------------------------------------------------------------------------------------------------------
    Y.ALL.ACCOUNTS = ""
**------------------------------------------------------------------------------------------------------------------------------------
**------------------------------------------------------------------------------------------------------------------------------------
**PRIMERO PARA DICHO CLIENTE OBTENGO TODAS SUS CUENTAS, Y A SU VEZ PARA CADA CUENTA OBTENGO
**LOS REGISTROS CORRESPONDIENTE A CADA CUENTA DESDE LA TABLA ACCOUNT
**------------------------------------------------------------------------------------------------------------------------------------
    CALL F.READ(FN.CUS.PRD,F.ID,R.CUS.PRD, FV.CUS.PRD, CUS.PRD.ERR)
    Y.CUS.PRD = R.CUS.PRD<PRD.PRODUCT.ID>
    Y.CAN.CUS.PRD = DCOUNT(Y.CUS.PRD,@VM)

    FOR P = 1 TO Y.CAN.CUS.PRD STEP 1

        T.CONTINUE.FLAG  = "NO"
        Y.CTA.ACTUAL   = R.CUS.PRD<PRD.PRODUCT.ID,P>
        Y.CTA.ACTUAL.EST  = R.CUS.PRD<PRD.PRD.STATUS,P>

        IF Y.CTA.ACTUAL.EST EQ "CLOSED" THEN
            CONTINUE
        END

        CALL F.READ(FN.ACC,Y.CTA.ACTUAL,R.ACC, FV.ACC, ACC.ERR)

        Y.RECORD.STATUS  = R.ACC<AC.RECORD.STATUS>

        IF Y.RECORD.STATUS EQ "CLOSED" THEN
            CONTINUE
        END

        Y.ACCOUNT.NUMBER  = Y.CTA.ACTUAL
        Y.CUSTOMER    = R.ACC<AC.CUSTOMER>
        Y.ONLINE.ACTUAL.BAL = R.ACC<AC.ONLINE.ACTUAL.BAL>
        Y.DATE.LAST.CR.CUST = R.ACC<AC.DATE.LAST.CR.CUST>
        Y.DATE.LAST.DR.CUST = R.ACC<AC.DATE.LAST.DR.CUST>
        Y.AMNT.LAST.CR.CUST = R.ACC<AC.AMNT.LAST.CR.CUST>
        Y.AMNT.LAST.DR.CUST = R.ACC<AC.AMNT.LAST.DR.CUST>
        Y.RELATION.CODE  = R.ACC<AC.RELATION.CODE>
        Y.CATEGORY   = R.ACC<AC.CATEGORY>
        Y.JOINT.HOLDER  = R.ACC<AC.JOINT.HOLDER>

*---------------------------------------------------------------------------------------------------------------------------
*Omitir cuentas de prestamos cancelados.
*Excluir las cuentas entre las categorias 3000 a 3999 que en el registro de ACCOUNT tengan el ONLINE.ACTUA.BAL con valor 0
*---------------------------------------------------------------------------------------------------------------------------
        IF (Y.CATEGORY GE 3000 AND Y.CATEGORY LE 3999) AND Y.ONLINE.ACTUAL.BAL EQ 0 THEN
            CONTINUE
        END

        GOSUB GET_CATEGORY_D
        GOSUB GET_JOINT_JOLDER_D
        GOSUB GET_INFO_CERTIFICADO
  
        Y.ARRANGEMENT.ID = R.ACC<AC.ARRANGEMENT.ID>

        Y.ALT.ACCT.ID  = R.ACC<AC.ALT.ACCT.ID,1>

        Y.CARD.NUM = R.ACC<AC.ALT.ACCT.ID,2>

        IF LEN(Y.ALT.ACCT.ID) LT 5 THEN

            Y.ALT.ACCT.ID = Y.CTA.ACTUAL

        END


        IF LEN(Y.CARD.NUM) GE 16 THEN

            GOSUB MASK.CARD.NUM

            Y.ALT.ACCT.ID  = Y.ALT.ACCT.ID: @VM : Y.MASK.CARD.NUM

            Y.MASK.CARD.NUM = ''

        END

        Y.CARD.NUM = R.ACC<AC.ALT.ACCT.ID,3>

        IF LEN(Y.CARD.NUM) GE 16 THEN

            GOSUB MASK.CARD.NUM

            Y.ALT.ACCT.ID  = Y.ALT.ACCT.ID: @VM : Y.MASK.CARD.NUM

            Y.MASK.CARD.NUM = ''

        END


        CALL GET.LOC.REF("ACCOUNT", "L.AC.REINVESTED",ACC.POS)

        Y.L.AC.REINVESTED = R.ACC<AC.LOCAL.REF,ACC.POS>

        IF Y.CUSTOMER EQ '' THEN
            GOSUB GET_HIST
        END

        GOSUB SET_FINAL
        GOSUB ADD_ALL_ACCT
    NEXT P

    GOSUB GET_JOINT_CONTRACTS

GET_HIST:
    T.CONTINUE.FLAG  = "NO"
    Y.RECORD.STATUS  = ''
    HIS.REC    = ''
    YERROR     = ''
    FN.AC.HIS    = 'F.ACCOUNT$HIS' ; F.AC.HIS = ''

    CALL OPF(FN.AC.HIS,F.AC.HIS)
    CALL EB.READ.HISTORY.REC(F.AC.HIS,Y.CTA.ACTUAL,HIST.REC,YERROR)

    Y.RECORD.STATUS  = HIST.REC<AC.RECORD.STATUS>

    IF Y.RECORD.STATUS EQ "CLOSED" THEN
        T.CONTINUE.FLAG  = "SI"
    END

    Y.ACCOUNT.NUMBER  = Y.CTA.ACTUAL
    Y.CUSTOMER    = HIST.REC<AC.CUSTOMER>
    Y.ONLINE.ACTUAL.BAL = HIST.REC<AC.ONLINE.ACTUAL.BAL>
    Y.DATE.LAST.CR.CUST = HIST.REC<AC.DATE.LAST.CR.CUST>
    Y.DATE.LAST.DR.CUST = HIST.REC<AC.DATE.LAST.DR.CUST>
    Y.AMNT.LAST.CR.CUST = HIST.REC<AC.AMNT.LAST.CR.CUST>
    Y.AMNT.LAST.DR.CUST = HIST.REC<AC.AMNT.LAST.DR.CUST>
    Y.RELATION.CODE  = HIST.REC<AC.RELATION.CODE>
    Y.CATEGORY   = HIST.REC<AC.CATEGORY>
    Y.JOINT.HOLDER  = HIST.REC<AC.JOINT.HOLDER>

    GOSUB GET_CATEGORY_D
    GOSUB GET_JOINT_JOLDER_D
    GOSUB GET_INFO_CERTIFICADO

    Y.ARRANGEMENT.ID = HIST.REC<AC.ARRANGEMENT.ID>
    Y.ALT.ACCT.ID  = HIST.REC<AC.ALT.ACCT.ID,1>

    CALL GET.LOC.REF("ACCOUNT", "L.AC.REINVESTED",ACC.POS)
    Y.L.AC.REINVESTED  = HIST.REC<AC.LOCAL.REF,ACC.POS>

RETURN

GET_JOINT_CONTRACTS:
    CALL F.READ(FN.JOINT.CONTRACTS.XREF,F.ID,R.JOINT.CONTRACTS.XREF, FV.JOINT.CONTRACTS.XREF, JOINT.CONTRACTS.XREF.ERR)
    Y.CUS.PRD = R.JOINT.CONTRACTS.XREF

    Y.CAN.CUS.PRD = DCOUNT(Y.CUS.PRD,@FM)
    FOR J.VAR = 1 TO Y.CAN.CUS.PRD STEP 1
        FINDSTR Y.CTA.ACTUAL IN Y.ALL.ACCOUNTS SETTING Ap, Vp THEN
**No hago nada
            T.CONTINUE.FLAG  = "SI"
            CONTINUE
        END ELSE

            T.CONTINUE.FLAG  = "NO"
            Y.CTA.ACTUAL   = R.JOINT.CONTRACTS.XREF<J.VAR>

            CALL F.READ(FN.ACC,Y.CTA.ACTUAL,R.ACC, FV.ACC, ACC.ERR)
            Y.RECORD.STATUS  = R.ACC<AC.RECORD.STATUS>
            IF Y.RECORD.STATUS EQ "CLOSED" THEN
                CONTINUE
            END

            Y.ACCOUNT.NUMBER  = Y.CTA.ACTUAL
            Y.CUSTOMER    = R.ACC<AC.CUSTOMER>
            Y.ONLINE.ACTUAL.BAL = R.ACC<AC.ONLINE.ACTUAL.BAL>
            Y.DATE.LAST.CR.CUST = R.ACC<AC.DATE.LAST.CR.CUST>
            Y.DATE.LAST.DR.CUST = R.ACC<AC.DATE.LAST.DR.CUST>
            Y.AMNT.LAST.CR.CUST = R.ACC<AC.AMNT.LAST.CR.CUST>
            Y.AMNT.LAST.DR.CUST = R.ACC<AC.AMNT.LAST.DR.CUST>
            Y.RELATION.CODE  = R.ACC<AC.RELATION.CODE>
            Y.CATEGORY   = R.ACC<AC.CATEGORY>
            Y.JOINT.HOLDER  = R.ACC<AC.JOINT.HOLDER>

            GOSUB GET_CATEGORY_D
            GOSUB GET_JOINT_JOLDER_D
            GOSUB GET_INFO_CERTIFICADO

            Y.ARRANGEMENT.ID = R.ACC<AC.ARRANGEMENT.ID>
            Y.ALT.ACCT.ID  = R.ACC<AC.ALT.ACCT.ID,1>

            Y.CARD.NUM = R.ACC<AC.ALT.ACCT.ID,2>


            IF LEN(Y.CARD.NUM) GE 16 THEN

                GOSUB MASK.CARD.NUM

                Y.ALT.ACCT.ID  = Y.ALT.ACCT.ID: @VM : Y.MASK.CARD.NUM

                Y.MASK.CARD.NUM = ''

            END


            Y.CARD.NUM = R.ACC<AC.ALT.ACCT.ID,3>


            IF LEN(Y.CARD.NUM) GE 16 THEN

                GOSUB MASK.CARD.NUM

                Y.ALT.ACCT.ID  = Y.ALT.ACCT.ID: @VM : Y.MASK.CARD.NUM

                Y.MASK.CARD.NUM = ''

            END


            CALL GET.LOC.REF("ACCOUNT", "L.AC.REINVESTED",ACC.POS)
            Y.L.AC.REINVESTED  = R.ACC<AC.LOCAL.REF,ACC.POS>

            IF Y.CUSTOMER EQ '' THEN
                GOSUB GET_HIST
            END

            GOSUB SET_FINAL
            GOSUB ADD_ALL_ACCT
        END

    NEXT J.VAR
RETURN

GET_CATEGORY_D:
    Y.CATEGORY.DESC = ""
    CALL CACHE.READ(FN.CAT, Y.CATEGORY, R.CAT, CAT.ERR)      ;*R22 Auto conversion
    Y.CATEGORY.DESC  = R.CAT<EB.CAT.DESCRIPTION>
RETURN

ADD_ALL_ACCT:
    IF Y.ALL.ACCOUNTS EQ "" THEN
        Y.ALL.ACCOUNTS = Y.CTA.ACTUAL
    END
    IF Y.ALL.ACCOUNTS NE "" THEN
        Y.ALL.ACCOUNTS = Y.ALL.ACCOUNTS : @VM : Y.CTA.ACTUAL
    END
RETURN

GET_JOINT_JOLDER_D:
    Y.JOINT.HOLDER.DESC = ""
    CALL F.READ(FN.CUS,Y.JOINT.HOLDER,R.CUS, FV.CUS, CUS.ERR)
    Y.JOINT.HOLDER.DESC = R.CUS<EB.CUS.NAME.1>
RETURN

GET_INFO_CERTIFICADO:
**----------------------------------------------------------------------------------------------------------------------
**Las categorias que identifican los certificados estan en los siguientes rangos: entre 6600 y 6618 y entre 6630 y 6699.
**----------------------------------------------------------------------------------------------------------------------
    Y.OFICINA.CERT = ""
    Y.APERTURA.CERT = ""
    IF (Y.CATEGORY GT 6599 AND Y.CATEGORY LT 6619) OR (Y.CATEGORY GT 6629 AND Y.CATEGORY LT 6700) THEN
        CALL F.READ(FN.AZ.ACC,Y.CTA.ACTUAL,R.AZ.ACC, FV.AZ.ACC, AZ.ACC.ERR)
        Y.OFICINA.CERT = R.AZ.ACC<AZ.CO.CODE>
        Y.APERTURA.CERT = R.AZ.ACC<AZ.VALUE.DATE>
    END
RETURN

SET_FINAL:
    IF T.CONTINUE.FLAG NE "SI" THEN
        Y.FINAL<-1>   = Y.ACCOUNT.NUMBER : "*" : F.ID : "*" : Y.ONLINE.ACTUAL.BAL : "*" : Y.DATE.LAST.CR.CUST : "*" : Y.DATE.LAST.DR.CUST : "*" : Y.AMNT.LAST.CR.CUST : "*" : Y.AMNT.LAST.DR.CUST : "*" : Y.RELATION.CODE : "*" : Y.CATEGORY : "*" : Y.CATEGORY.DESC : "*" : Y.ARRANGEMENT.ID : "*" : Y.ALT.ACCT.ID : "*" : Y.L.AC.REINVESTED : "*" : Y.JOINT.HOLDER.DESC : "*" : Y.OFICINA.CERT : "*" : Y.APERTURA.CERT
    END
RETURN


MASK.CARD.NUM:

    Y.INT = 1
    Y.LEN.CARD = 16


    CALL F.READ(FN.APAP.PARAM.DB.CR.MASK,"L.APAP.TD.PEND.LIQ",R.MASK.PARAM,F.APAP.PARAM.DB.CR.MASK,ERR.MASK.PARAM)
    IF R.MASK.PARAM THEN
        Y.PARAM.DIGIT = R.MASK.PARAM<APAP.MASK.MASKING.DIGITS>
        CHANGE " " TO @FM IN Y.PARAM.DIGIT        ;*R22 Auto conversion
        LOOP
        WHILE Y.INT LE Y.LEN.CARD
            Y.QUO = Y.INT/4
            Y.QUO.DEC = FIELD(Y.QUO,".",2,1)
            LOCATE Y.INT IN Y.PARAM.DIGIT SETTING Y.DIGI.POS THEN
                IF (Y.QUO.DEC NE "") OR (Y.INT EQ Y.LEN.CARD) THEN
                    Y.MASK.CARD.NUM := "X"
                END ELSE
                    Y.MASK.CARD.NUM := "X-"
                END
            END ELSE
                IF (Y.QUO.DEC NE "") OR (Y.INT EQ Y.LEN.CARD) THEN
                    Y.MASK.CARD.NUM := Y.CARD.NUM[Y.INT,1]
                END ELSE
                    Y.MASK.CARD.NUM := Y.CARD.NUM[Y.INT,1]:"-"
                END
            END
            Y.INT += 1
        REPEAT
    END

RETURN


END

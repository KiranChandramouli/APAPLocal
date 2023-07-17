$PACKAGE APAP.LAPAP
* @ValidationCode : MjoxNjUyNDQxNzU3OkNwMTI1MjoxNjg5MjUxMDY2MDk5OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jul 2023 17:54:26
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
SUBROUTINE L.APAP.RTE.CUST.AND.DATE.TXN(Y.FINAL)
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       = to EQ, BP Removed
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON                      ;*R22 Auto conversion - Start
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.RTE.CUST.CASHTXN     ;*R22 Auto conversion - End

*OBJECTOS PARA ABRIR EL ARCHIVO REDO.RTE.CUST.CASHTXN
    FN.TABLE = "F.REDO.RTE.CUST.CASHTXN"
    FT.RTE = ""
    RS.RTE = ""
    ERR.RTE = ""
    Y.POS = ""
    Y.HIS.SUF = ""

*PARA EJECUTAR QUERY
    SEL.LIST = ""
    NO.OF.REC = ""
    SEL.ERR = ""

*OBTENEMOS LOS CAMPOS ENVIADOS DESDE EL SS
    LOCATE "CUST.ID" IN D.FIELDS<1> SETTING CUS.POS THEN
        CUST.ID = D.RANGE.AND.VALUE<CUS.POS>
    END

    LOCATE "DATE.FROM" IN D.FIELDS<1> SETTING CUS.POS THEN
        DATE.FROM = D.RANGE.AND.VALUE<CUS.POS>
    END
*FIN

*PARA ABRIR EL ACHIVO DE REDO.RTE.CUST.CASHTXN
    CALL OPF(FN.TABLE, FT.RTE)

* FORMAMOS EL QUERY A EJECUTAR
    SEL.CMD = "SELECT " : FN.TABLE : " WITH @ID LIKE ..." : CUST.ID : "." : DATE.FROM : "..."

* EGECUTAMOS LA CONSULTA A LA TABLA DE REDO.RTE.CUST.CASHTXN
    CALL EB.READLIST(SEL.CMD, SEL.LIST,"", NO.OF.REC, SEL.ERR)

    LOOP
        REMOVE Y.RTE.ID FROM SEL.LIST SETTING RTE.POS

    WHILE Y.RTE.ID DO

        CALL F.READ(FN.TABLE, Y.RTE.ID, RS.RTE, FT.RTE, ERR.RTE)

*CAMPOR A RETORNAR
        VAL.NO1 = Y.RTE.ID
        VAL.NO2 = "|" : RS.RTE<RTE.INITIAL.ID>
        VAL.NO3 = "|" : RS.RTE<RTE.TXN.ID>
        VAL.NO4 = "|" : RS.RTE<RTE.BRANCH.CODE>
        VAL.NO5 = ""

        IF RS.RTE<RTE.CASH.AMOUNT> EQ '' THEN
            VAL.NO5 = "|0"

        END ELSE
            VAL.NO5 = "|" : RS.RTE<RTE.CASH.AMOUNT>
        END

        Y.FINAL<-1> = VAL.NO1 : VAL.NO2 : VAL.NO3 : VAL.NO4 : VAL.NO5

    REPEAT

END

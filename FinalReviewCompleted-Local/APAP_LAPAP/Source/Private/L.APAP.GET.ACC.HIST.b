* @ValidationCode : MjotMjA5MTQzNDcxNDpDcDEyNTI6MTY4MjMzMTMyMjQ3MjpJVFNTOi0xOi0xOjI5NToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 295
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.GET.ACC.HIST(Y.FINAL)
*--------------------------------------------------------------------------------------------------
* Description           : Esta rutina retorma el historico de un producto (cuenta, prestamo o certificado)
* Developed On          : 08/01/2019
* Developed By          : Anthony Martinez
* Development Reference : ---
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
* Defect Reference       Modified By                    Date of Change        Change Details
* --------               Anthony Martinez               08/01/2019            Creation
* --------               Anthony Martinez               16/09/2019            Cambio para ver las transacciones del dia en dias feriados
*
* 21-APR-2023     Conversion tool    R22 Auto conversion      = to EQ, F.READ to CACHE.READ, BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TRANSACTION ;*R22 Auto conversion - END

*--OBTENEMOS LOS CAMPOS ENVIADOS DESDE EL SS
    LOCATE "ACCOUNT" IN D.FIELDS<1> SETTING ACCOUNT.POS THEN
        Y.ACCOUNT = D.RANGE.AND.VALUE<ACCOUNT.POS>
    END

    LOCATE "DATE.FROM" IN D.FIELDS<1> SETTING DATE.FROM.POS THEN
        Y.DATE.FROM = D.RANGE.AND.VALUE<DATE.FROM.POS>
    END

    LOCATE "DATE.TO" IN D.FIELDS<1> SETTING DATE.TO.POS THEN
        Y.DATE.TO = D.RANGE.AND.VALUE<DATE.TO.POS>
    END

*Y.DATE.FROM = SUBSTRINGS(Y.DATE.FROM, 3, 6) : "0000"
*Y.DATE.TO   = SUBSTRINGS(Y.DATE.TO, 3, 6) : "2400"

    Y.WEEKEND = OCONV(Y.DATE.TO,'DW')


    IF Y.WEEKEND EQ 1 OR Y.WEEKEND EQ 2 THEN

        CALL  CDT('',Y.DATE.TO,'+1W')

    END


*SEL.CMD = "SELECT FBNK.STMT.ENTRY WITH ACCOUNT.NUMBER EQ " : Y.ACCOUNT : " AND DATE.TIME GT " : Y.DATE.FROM : " AND DATE.TIME LT " : Y.DATE.TO : " AND @ID UNLIKE F... "
    SEL.CMD = "SELECT FBNK.STMT.ENTRY WITH ACCOUNT.NUMBER EQ " : Y.ACCOUNT : " AND BOOKING.DATE GE " : Y.DATE.FROM : " AND BOOKING.DATE LE " : Y.DATE.TO : " AND @ID UNLIKE F... "
    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, SEL.ERR)

*--TABLE OBJECTS
    FN.STMT = "F.STMT.ENTRY"; FV.STMT = ""; R.STMT = ""; STMT.ERR = ""
    CALL OPF(FN.STMT, FV.STMT)

    LOOP
        REMOVE Y.REC.ID FROM SEL.LIST SETTING RTE.POS
    WHILE Y.REC.ID DO

        CALL F.READ(FN.STMT, Y.REC.ID, R.STMT, FV.STMT, STMT.ERR)

        Y.TXN      = R.STMT<AC.STE.TRANS.REFERENCE>
        Y.TXN.DATE = "20" : R.STMT<AC.STE.DATE.TIME>
        Y.AMOUNT   = R.STMT<AC.STE.AMOUNT.LCY>
        Y.TXN.CODE = R.STMT<AC.STE.TRANSACTION.CODE>

        FN.TRANSACTION = "F.TRANSACTION"; FV.TRANSACTION = ""; R.TRANSACTION = ""; ERR.TRANSACTION = ""
        CALL OPF(FN.TRANSACTION, FV.TRANSACTION)

        CALL CACHE.READ(FN.TRANSACTION, Y.TXN.CODE, R.TRANSACTION, ERR.TRANSACTION) ;*R22 Auto conversion

        Y.TXN.DESC = R.TRANSACTION<AC.TRA.NARRATIVE, 1>

        Y.FINAL<-1> = Y.TXN :"|": Y.TXN.DATE :"|": Y.AMOUNT :"|": Y.TXN.DESC

    REPEAT

END

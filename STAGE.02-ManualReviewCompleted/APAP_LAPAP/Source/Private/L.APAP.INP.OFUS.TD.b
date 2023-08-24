$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.INP.OFUS.TD (Y.OFS.TRANSACTION.ID, Y.DYN.MAPPING.IN, Y.DYN.REQUEST.OFS.KEY, Y.DYN.REQUEST.VALUE, Y.DYN.REQUEST.OFS.TYPE, Y.ADDNL.INFO, Y.ERROR)
*--------------------------------------------------------------------------------------------------
* Description           : This routine search the account of a card
* Developed On          : 31/08/2020
* Developed By          : Estalin Valerio
* Development Reference : ---
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
* Defect Reference       Modified By                    Date of Change        Change Details
* --------               Estalin Valerio                31/08/2020            Creation
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - > to GT , FM to @FM and T24.BP is removed from Insert
* 21-APRIL-2023      Harsha                R22 Manual Conversion - No changes   
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.LATAM.CARD.CUSTOMER

**---------------------------------------
**ABRIR LA TABLA F.ACCOUNT
**---------------------------------------
    FN.ACC = "F.ACCOUNT"
    FV.ACC = ""
    R.ACC = ""
    ACC.ERR = ""

    FN.CARD.CUSTOMER  = "F.LATAM.CARD.CUSTOMER"
    F.CARD.CUSTOMER  = ""
    CALL OPF(FN.CARD.CUSTOMER,F.CARD.CUSTOMER)

**-------------------------------------------------------------

**-------------------------------------------------------------
** OBTENER CAMPO CUENTA
**-------------------------------------------------------------

    LOCATE "CREDIT.ACCT.NO" IN Y.DYN.REQUEST.OFS.KEY<1> SETTING CUS.POS THEN
        Y.AC.NO = Y.DYN.REQUEST.VALUE<CUS.POS>
    END

**---------------------------------------------------------------------------------------------
** OBTENER ENTRADA
**---------------------------------------------------------------------------------------------
    Y.AC.NO.POS = CHANGE(Y.AC.NO,'-', @FM);

    Y.CANT = DCOUNT(Y.AC.NO.POS,@FM)

    IF (Y.CANT GT 1)
    THEN

        Y.CODIGO.CLIENTE = Y.AC.NO.POS<1>
        Y.LAST.DIGIT.CARD = Y.AC.NO.POS<2>

    END

**-----------------------------------------------------------------------------------
** Buscar cliente de la cuenta
**-----------------------------------------------------------------------------------

**---------------------------BUSCAR LA CUENTA DE LA TARJETA-------------------------------

    IF LEN(Y.LAST.DIGIT.CARD) EQ 4 THEN

        CALL F.READ(FN.CARD.CUSTOMER, Y.CODIGO.CLIENTE,R.CARD.CUSTOMER,F.CARD.CUSTOMER,ERROR.CUSTOMER)

        Y.CARDS = R.CARD.CUSTOMER<APAP.DC.CARD.NO>
        Y.CUENTAS = R.CARD.CUSTOMER<APAP.DC.ACCOUNT.NO>
        Y.CARDS.COUNT = DCOUNT(Y.CARDS,@VM)

        FOR A=1 TO Y.CARDS.COUNT STEP 1

            Y.CARDS.CU = Y.CARDS<1,A>

            IF RIGHT(Y.CARDS.CU,4) EQ Y.LAST.DIGIT.CARD THEN
                Y.CUENTA = Y.CUENTAS<1,A>
            END

        NEXT A

        IF (Y.CUENTA NE "") THEN
            Y.DYN.REQUEST.VALUE<CUS.POS> = Y.CUENTA
        END

    END

RETURN

END

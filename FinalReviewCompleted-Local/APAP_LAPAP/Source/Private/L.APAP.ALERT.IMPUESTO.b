$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.ALERT.IMPUESTO(MENSAJE.ALERT)
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Raquel P. S.
* Program Name  : L.APAP.ALERT.IMPUESTO
* ODR NUMBER    :
*----------------------------------------------------------------------------------
* Description   : Deal slip routine attached to TT to retrieve ALERT WHEN AMMOUNT EXCEED OR BE EQUAL TO AMMOUNT
* In parameter  : None
* out parameter : None
*----------------------------------------------------------------------------------
* Date             Author             Reference         Description
* 7-9-2018      Raquel P. S.     CN009464    Initial creation
* Date                  who                   Reference              
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INCLUDE T24.BP TO $INSERT 
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES

*----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.TELLER

    GOSUB PROCESS

RETURN


*----------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------

    Y.MONTO = R.NEW(TT.TE.AMOUNT.LOCAL.1 )

    IF Y.MONTO LE 20000.00 THEN
        MENSAJE.ALERT = "* Acepto cobro comision por retiro en caja, de monto inferior al definido en tarifario vigente."
    END ELSE
        MENSAJE.ALERT = ""
    END

RETURN

END

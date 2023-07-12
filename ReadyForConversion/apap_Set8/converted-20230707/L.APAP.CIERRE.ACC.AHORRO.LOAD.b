*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Subrutina: L.APAP.CIERRE.ACC.AHORRO.LOAD
*  Creación: 05/10/2020
*     Autor: Félix Trinidad
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.CIERRE.ACC.AHORRO.LOAD
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT T24.BP I_F.ACCOUNT.CLOSURE
    $INSERT BP I_F.ST.CONTROL.CUENTA.AHORRO
    $INSERT LAPAP.BP L.APAP.CIERRE.ACC.AHORRO.COMO
          
    GOSUB INIT
 
    RETURN

INIT:
*****   
        Y.VAR.DATE = TODAY
        Y.VAR.CATEG.EXC = 6013 :@FM: 6014 :@FM: 6015 :@FM: 6016 :@FM: 6017 :@FM: 6018 :@FM: 6019 :@FM: 6020;
                
        FN.ACCOUNT='F.ACCOUNT'
        F.ACCOUNT=''
        CALL OPF(FN.ACCOUNT,F.ACCOUNT)

        FN.CONTROL.CUENTA.AHORRO ='F.ST.CONTROL.CUENTA.AHORRO'
        F.CONTROL.CUENTA.AHORRO=''
        CALL OPF(FN.CONTROL.CUENTA.AHORRO,F.CONTROL.CUENTA.AHORRO)

RETURN

END

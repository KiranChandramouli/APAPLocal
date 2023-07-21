$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Subrutina: L.APAP.CIERRE.ACC.AHORRO.LOAD
*  Creación: 05/10/2020
*     Autor: Félix Trinidad
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION

*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   T24.BP,BP is Removed , INSERT FILE MODIFIED
*---------------------------------------------------------------------------------------	-
SUBROUTINE L.APAP.CIERRE.ACC.AHORRO.LOAD
    $INSERT I_COMMON
    $INSERT I_EQUATE ;*r22 MANUAL CODE CONVERSION
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_F.ST.CONTROL.CUENTA.AHORRO ;*R22 MANUAL CODE CONVERSION
    $INSERT I_L.APAP.CIERRE.ACC.AHORRO.COMO ;* R22 MANUAL CODE CONVERSION FILE NAME MODIFIED
          
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

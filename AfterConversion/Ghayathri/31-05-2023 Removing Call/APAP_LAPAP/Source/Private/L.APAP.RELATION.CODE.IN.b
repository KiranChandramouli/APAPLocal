$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.RELATION.CODE.IN
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - I to I.VAR , ++ to +=1 and T24.BP is removed from Insert
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    Y.RELACION.ID = R.NEW(AC.RELATION.CODE)
    Y.CONTADOR = 0
    Y.CAN.CS = DCOUNT(Y.RELACION.ID,@VM)
    FOR I.VAR = 1 TO Y.CAN.CS
        IF Y.RELACION.ID<1,I.VAR> EQ '501' THEN
            Y.CONTADOR += 1
        END
        IF Y.RELACION.ID<1,I.VAR> EQ '500' THEN
            Y.CONTADOR += 1
        END
    NEXT I.VAR
    IF Y.CONTADOR GT 1 THEN
        MESSAGE = "NO PERMITIDO AGREGAR MAS DE UNA RELACION 500 O 501"
        E = MESSAGE
        ETEXT = E
        CALL ERR
    END
END

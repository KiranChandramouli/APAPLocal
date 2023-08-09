*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
*Fecha Modif: 3/07/2023
*Autor: Laura Novas
*Descripcion: Se obtiene el ID del cliente a partir de una una cuenta o certificado cancelado. 

    SUBROUTINE LAPAP.CLOS.CLOSCUS

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_ENQUIRY.COMMON
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT T24.BP I_F.ACCOUNT.CLOSURE

    FN.ACC = "F.ACCOUNT$HIS"
    FV.ACC = ""
    CALL OPF(FN.ACC,FV.ACC)

    ACC = O.DATA

    CALL EB.READ.HISTORY.REC(FV.ACC,ACC,R.ACC,ACC.ERROR)
    OPEND = R.ACC<AC.CUSTOMER>
    O.DATA = OPEND

    RETURN

 END

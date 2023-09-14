$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.MOD.PR.OVERR
*----------------------------------------------------------------------------------------------------
* Description           : Esta rutina genera un mensaje override cuando se dispara cualquier activiad de AAA
*                         Atachada a la version : AA.ARRANGEMENT.ACTIVITY,L.APAP.VER.MANTPREST.RRHH
* Developed On          : 13-12-2021
* Developed By          : APAP
* Development Reference : MDR-1112
*----------------------------------------------------------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM and T24.BP is removed from Insert
* 21-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY

    GOSUB PROCESO

RETURN

PROCESO:
    CURR.NO = DCOUNT(R.NEW(AA.ARR.ACT.CURR.NO),@VM)
    VAR.OVERRIDE.ID  = 'L.APAP.RHH.AUTH'
    TEXT    = VAR.OVERRIDE.ID
    CALL STORE.OVERRIDE(CURR.NO + 1)
RETURN

END

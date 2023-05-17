*-------------------------------------------------------------------------------------------------------
* <Rating>-20</Rating>
*-------------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.E.CNV.GET.ADDRESS
*-------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.CNV.GET.ADDRESS
*-------------------------------------------------------------------------------------------------------
*Description  : This is a conversion routine used to display From.date and Until.date
*In Parameter : N/A
*Out Parameter: O.DATA
*Linked File  : REDO.E.CNV.ACCOUNT.DETAILS
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*     Date            Who                              Reference               Description
*    ------          ------                            -----------             --------------
*  30-10-2010       Prabhu N            ODR-2010-08-0031           Initial Creation
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.DE.ADDRESS
$INSERT I_F.DE.PRODUCT
*---------------------------------------------------------------------------------------------------------
  GOSUB PROCESS
  RETURN
*---------------------------------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------------------------------
  FN.DE.ADDRESS='F.DE.ADDRESS'
  F.DE.ADDRESS=''
  CALL OPF(FN.DE.ADDRESS,F.DE.ADDRESS)
  CALL F.READ(FN.DE.ADDRESS,O.DATA,R.DE.ADDRESS,F.DE.ADDRESS,ERR)
  IF R.DE.ADDRESS EQ '' THEN
    Y.ID.FIRST=FIELDS(O.DATA,'.',1,2)
    Y.ID.FIRST='PRINT-1'
    CALL F.READ(FN.DE.ADDRESS,O.DATA,R.DE.ADDRESS,F.DE.ADDRESS,ERR)
  END
  LOC.REF.APPLICATION='DE.ADDRESS'
  LOC.REF.FIELDS='L.DA.NO.DIR':VM:'L.CU.URB.ENS.RE ':'L.CU.RES.SECTOR':VM:'L.DA.PAIS':VM:'L.DA.APT.POSTAL'
  LOC.REF.POS   =''
  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
  Y.L.DA.NO.DIR    =R.DE.ADDRESS<DE.ADD.LOCAL.REF><1,LOC.REF.POS<1,1>>
  Y.L.CU.URB.ENS.RE=R.DE.ADDRESS<DE.ADD.LOCAL.REF><1,LOC.REF.POS<1,2>>
  Y.L.CU.RES.SECTOR=R.DE.ADDRESS<DE.ADD.LOCAL.REF><1,LOC.REF.POS<1,3>>
  Y.L.DA.PAIS      =R.DE.ADDRESS<DE.ADD.LOCAL.REF><1,LOC.REF.POS<1,4>>
  Y.L.DA.APT.POSTAL  =R.DE.ADDRESS<DE.ADD.LOCAL.REF><1,LOC.REF.POS<1,5>>
  O.DATA<1,1>=R.DE.ADDRESS<DE.ADD.STREET.ADDRESS> : Y.L.DA.NO.DIR
  O.DATA<1,2>=Y.L.CU.URB.ENS.RE : Y.L.CU.RES.SECTOR
  O.DATA<1,3>=R.DE.ADDRESS<DE.ADD.COUNTRY.CODE>:R.DE.ADDRESS<DE.ADD.TOWN.COUNTY>
  O.DATA<1,4>=Y.L.DA.PAIS
  O.DATA<1,5>=Y.L.DA.APT.POSTAL
  RETURN
END

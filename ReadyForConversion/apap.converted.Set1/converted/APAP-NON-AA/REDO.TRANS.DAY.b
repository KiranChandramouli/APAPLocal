*-----------------------------------------------------------------------------
* <Rating>-27</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.TRANS.DAY
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.TRANS.DAY
*--------------------------------------------------------------------------------------------------------
*Description       :
*
*Linked With       : NOFILE ENQUIRY
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : ACCOUNT
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*  Date                 Who                  Reference                 Description
*  ------               -----               -------------              -------------
* 20.12.2010           Manju G          ODR-2010-12-0495           Initial Creation
**********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.CUSTOMER
$INSERT I_ENQUIRY.COMMON

  GOSUB PROCESS
  RETURN
PROCESS:
**********
  Y.ID=O.DATA
*TO BE DISPLAYED
  Y.DATE = TODAY[7,2]
  Y.MONTH.POS = TODAY[5,2]

  Y.MONTH = "Enero":FM:"Febrero":FM:"Marzo":FM:"Abril":FM:"Mayo":FM:"Junio":FM:"Julio":FM:"Agosto":FM:"Septiembre":FM:"Octubre":FM:"Noviembre":FM:"Diciembre"
  Y.MONTH.ES = Y.MONTH<Y.MONTH.POS>

  DATE.TODAY=TODAY
  DATE.TODAY=ICONV(DATE.TODAY,'D')
  Y.DAY.ENGLISH = OCONV(DATE.TODAY,'DWA')
*TO BE DISPLAYED
  BEGIN CASE
  CASE Y.DAY.ENGLISH EQ 'MONDAY'
    Y.SPANISH.WEEK = 'Lunes'
  CASE Y.DAY.ENGLISH EQ 'TUESDAY'
    Y.SPANISH.WEEK = 'Martes'
  CASE Y.DAY.ENGLISH EQ 'WEDNESDAY'
    Y.SPANISH.WEEK = 'Miercoles'
  CASE Y.DAY.ENGLISH EQ 'THURSDAY'
    Y.SPANISH.WEEK = 'Jueves'
  CASE Y.DAY.ENGLISH EQ 'FRIDAY'
    Y.SPANISH.WEEK = 'Viernes'
  CASE Y.DAY.ENGLISH EQ 'SATURDAY'
    Y.SPANISH.WEEK = 'Sabado'
  CASE Y.DAY.ENGLISH EQ 'SUNDAY'
    Y.SPANISH.WEEK = 'Domingo'
  END CASE
*Y.SPANISH.WEEK = 'Lunes':FM:'Martes':FM:'Miercoles':FM:'Jueves':FM:'Viemes':FM:'Sabado':FM:'Domingo'
*                   M          T                W           T         F            SAT         SUN
**TO BE DISPLAYED
  Y.THE = 'de'
*TO BE DISPLAYED
  IN.YEAR=TODAY[1,4]
*Viernes, 31 de Diciembre de 2010
  O.DATA = "FD1=" : Y.SPANISH.WEEK:',':' ':Y.DATE:' ':Y.THE:' ':Y.MONTH.ES:' ':Y.THE:' ':IN.YEAR

  RETURN
32 END

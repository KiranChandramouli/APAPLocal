*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FORMAT.CHQ.DATE(Y.DATE)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Attached to   : CHQ.PRINT.ADMIN(Deal Slip)
* ODR NUMBER    : ODR-2009-10-0795
*--------------------------------------------------------------------------------------------------
* Description   : This routine is used for Deal slip. Will return the date in specified format
* In parameter  :
* out parameter : Y.DATE
*--------------------------------------------------------------------------------------------------
* Modification History :
*--------------------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 27-05-2011        Bharath G        PACS00032271      Initial Creation
*--------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.PRINT.CHQ.LIST

  Y.GET.DATE = R.NEW(PRINT.CHQ.LIST.ISSUE.DATE)

  Y.DAY   = Y.GET.DATE[7,2]
  Y.MONTH = Y.GET.DATE[5,2]
  Y.YEAR  = Y.GET.DATE[1,4]

  IF Y.DATE EQ 'US.CHQ.DATE' THEN
    TEMP.DATE = Y.MONTH[1,1]:" ":Y.MONTH[2,1]:" ":Y.DAY[1,1]:" ":Y.DAY[2,1]:" ":Y.YEAR[1,1]:" ":Y.YEAR[2,1]:" ":Y.YEAR[3,1]:" ":Y.YEAR[4,1]
  END ELSE
    IF (R.NEW(PRINT.CHQ.LIST.SET.PRINTER) EQ 'RICOH' AND R.NEW(PRINT.CHQ.LIST.CHQ.TYPE) EQ 'MANAGER') THEN
      TEMP.DATE = Y.DAY[1,1]:" ":Y.DAY[2,1]:" ":Y.MONTH[1,1]:" ":Y.MONTH[2,1]:"  ":Y.YEAR[1,1]:" ":Y.YEAR[2,1]:" ":Y.YEAR[3,1]:" ":Y.YEAR[4,1]
    END ELSE
      TEMP.DATE = Y.DAY[1,1]:" ":Y.DAY[2,1]:" ":Y.MONTH[1,1]:" ":Y.MONTH[2,1]:" ":Y.YEAR[1,1]:" ":Y.YEAR[2,1]:" ":Y.YEAR[3,1]:" ":Y.YEAR[4,1]
    END
  END
  Y.DATE = TEMP.DATE

  RETURN
END

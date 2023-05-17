*
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE DR.REGN22.RCL.MARKET.TYPE
  $INSERT I_COMMON
  $INSERT I_EQUATE

  MKT.TYPE = COMI
  BEGIN CASE
  CASE MKT.TYPE EQ 'S'
    MKT.TYPE = 'SP'
  CASE MKT.TYPE EQ 'F'
    MKT.TYPE = 'FD'
  CASE MKT.TYPE EQ 'N'
    MKT.TYPE = 'ND'
  END CASE

  COMI = MKT.TYPE

  RETURN
END

*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.CAPITALISE.INT.SELECT

*****************************************************************************************
*----------------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Arulprakasam P
* Program Name  : REDO.B.CAPITALISE.INT.SELECT
*-----------------------------------------------------------------------------------------
* Description:
* This routine is a multithreaded routine to select the records in the mentioned applns
*------------------------------------------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              REFERENCE            DESCRIPTION
* 17.12.2010        ODR-2010-09-0251     INITIAL CREATION
*------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.CAPITALISE.COMMON


  SEL.CMD = ''
  LIST.INTEREST = ''
  BATCH.LIST.IDS = ''
  LOC.ID.VARIABLE = ''

  SEL.CMD = "SELECT ":FN.INT.REVERSE:" BY ACCOUNT"
  CALL EB.READLIST(SEL.CMD,LIST.INTEREST,'',NO.OF.REC,ERR)

  LOOP
    REMOVE INTEREST.ID FROM LIST.INTEREST SETTING INT.POS
  WHILE INTEREST.ID:INT.POS

    LOCATE INTEREST.ID IN LOC.ID.VARIABLE SETTING LOC.POS THEN

      BATCH.LIST.IDS<LOC.POS,-1> = INTEREST.ID
    END ELSE
      LOC.ID.VARIABLE<-1> = INTEREST.ID

      BATCH.LIST.IDS<-1> = INTEREST.ID
    END

  REPEAT

  CALL BATCH.BUILD.LIST('',BATCH.LIST.IDS)

  RETURN
*------------------------------------------------------------------------------------------
END

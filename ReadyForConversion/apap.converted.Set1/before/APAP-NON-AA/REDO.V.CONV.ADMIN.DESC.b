*-----------------------------------------------------------------------------
* <Rating>-8</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.CONV.ADMIN.DESC

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON

*DESCRIPTION:
*------------
*This routine is used to show the descriptions and act as conversion routine
*-------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 12-APR-2012       S.MARIMUTHU      PACS00189769
*-------------------------------------------------------------------------------

  Y.VAL = O.DATA


  VIRTUAL.TAB.ID = 'ADMIN.CHQ.TYPE'
  CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)
  Y.LOOKUP.LIST = VIRTUAL.TAB.ID<2>
  Y.LOOKUP.LIST = CHANGE(Y.LOOKUP.LIST,'_',FM )
  Y.DESC.LIST = VIRTUAL.TAB.ID<11>
  Y.DESC.LIST = CHANGE(Y.DESC.LIST,'_',FM)

  LOCATE Y.VAL IN Y.LOOKUP.LIST SETTING POS THEN

    Y.DATA = Y.DESC.LIST<POS,LNGG>
    IF Y.DATA EQ '' THEN
      O.DATA = Y.DESC.LIST<POS,1>
    END ELSE
      O.DATA = Y.DESC.LIST<POS,LNGG>
    END
  END

  RETURN

END

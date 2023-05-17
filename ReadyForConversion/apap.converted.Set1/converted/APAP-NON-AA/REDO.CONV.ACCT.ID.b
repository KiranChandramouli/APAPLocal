SUBROUTINE REDO.CONV.ACCT.ID

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*
* PROGRAM.NAME: REDO.CONV.ACCT.ID

* DESCRIPTION:
* This routine is used to spilt the account and company code separately.

* Modification History
* DATE            ODR           BY              DESCRIPTION

* 03-07-2011      PACS00056280  MARIMUTHU S


    Y.DATA = FIELD(O.DATA,'\',1)


    O.DATA = Y.DATA

RETURN

END

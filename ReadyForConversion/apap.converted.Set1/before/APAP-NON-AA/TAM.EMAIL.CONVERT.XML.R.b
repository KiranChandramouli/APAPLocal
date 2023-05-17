*-----------------------------------------------------------------------------
* <Rating>-104</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE TAM.EMAIL.CONVERT.XML.R(R.EMAIL, Y.EMAIL.INFO.XML, Y.ERROR)
*-----------------------------------------------------------------------------
*** <region name= Description>
*** <desc>Description </desc>
* This subroutine allows to convert an email from InforBasic RECORD to T24TAMEmail.xsd (on T24TAMEmail.jar library)
* Arguments:
*-----------------------------------------------------------------------------
* R.EMAIL          - Email Information (@see I_TAM.EMAIL.COMMON)
* Y.EMAIL.INFO.XML - The XML info using T24TAMEmail.xsd
* Y.ERROR          - Error on Processing, if blank the process was succesfully done
* Here, it is an example to be returned:
*-----------------------------------------------------------------------------
*                <?xml version="1.0" encoding="UTF-8"?>
*                <T24MailPackage xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="T24TAMEmail.xsd">
*                    <Email id="D20100217014987205307.1" password="xxxxx">
*                        <Address>
*                            <From>mb@temenos.com</From>
*                            <ReplyTo>mb@temenos.com</ReplyTo>
*                            <To>retailmgr@temenos.com</To>
*                        </Address>
*                        <Message type="Hi">
*                            <Subject>Alert notification  - New Savings A/c Opened</Subject>
*                            <Body>Message from T24 Bank&lt;br/&gt;&lt;br/&gt;Dear . Retail Manager&lt;br/&gt;&lt;br/&gt;We have the following Alert notification for you : New Savings A/c Opened&lt;br/&gt;Account Number : *5403&lt;br/&gt;Customer : 111633&lt;br/&gt;Product : 6601,Short Term Fixed Deposit&lt;br/&gt;Account Officer : Retail Banking Manager-Others&lt;br/&gt;&lt;br/&gt;Regards,</Body>
*                            <Attachment>REDO.PATH\buroCredito.txt</Attachment>
*                        </Message>
*                    </Email>
*                </T24MailPackage>
*** </region>
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
  $INSERT I_TAM.EMAIL.COMMON

  GOSUB INITIALISE
  GOSUB PROCESS
  IF Y.ERROR EQ "" THEN
    Y.BLANK.SPACE = ' '
    Y.EMAIL.INFO.XML = CHANGE( Y.EMAIL.INFO.XML, FM, Y.BLANK.SPACE)
    CALL CLEAN.XML.TEXT( THE.DATA, "REPLACE.CHARS", "TRUE" )
  END
  RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
  Y.EMAIL.INFO.XML = ""
  Y.EMAIL.INFO.XML<-1> = E_MAIL.FIRST.LINE
  Y.EMAIL.INFO.XML<-1> = E_MAIL.SECOND.LINE
  RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
* ====================================================
* EMAIL tag
* ====================================================
  Y.EMAIL.ID = R.EMAIL<E_MAIL.ID>
  IF Y.EMAIL.ID EQ "" THEN
    Y.EMAIL.ID = "D20100217014987205307.1"
  END
  Y.EMAIL.ID = '<Email id="' : Y.EMAIL.ID : '"'

* Password to Authenticate
  Y.EMAIL.PASSWORD = R.EMAIL<E_MAIL.PASSWORD>
  IF Y.EMAIL.PASSWORD NE "" THEN
    Y.EMAIL.ID = Y.EMAIL.ID : ' password = "' : Y.EMAIL.PASSWORD : '"'
  END
  Y.EMAIL.INFO.XML<-1> = Y.EMAIL.ID : '>'

* ====================================================
* Address
* ====================================================
  Y.EMAIL.INFO.XML<-1> = "<Address>"
* From
  Y.EMAIL.FROM = R.EMAIL<E_MAIL.FROM>
  IF Y.EMAIL.FROM EQ "" THEN
    Y.ERROR = "Email From attribute missed. Address.From is required."
    RETURN
  END
  Y.MV.TAG = "From"
  Y.MV.TO.PROCESS = Y.EMAIL.FROM
  GOSUB PROCESS.MV

* Reply To
  Y.MV.TO.PROCESS = R.EMAIL<E_MAIL.REPLYTO>
  IF Y.MV.TO.PROCESS NE "" THEN
    Y.MV.TAG = "ReplyTo"
    GOSUB PROCESS.MV
  END

* To
  Y.MV.TO.PROCESS = R.EMAIL<E_MAIL.TO>
  IF Y.MV.TO.PROCESS EQ "" THEN
    Y.ERROR = "Email To attribute missed. Address.To is required."
    RETURN
  END
  Y.MV.TAG = "To"
  GOSUB PROCESS.MV

* Cc
  Y.MV.TO.PROCESS = R.EMAIL<E_MAIL.CC>
  IF Y.MV.TO.PROCESS NE "" THEN
    Y.MV.TAG = "Cc"
    GOSUB PROCESS.MV
  END

* Bcc
  Y.MV.TO.PROCESS = R.EMAIL<E_MAIL.BCC>
  IF Y.MV.TO.PROCESS NE "" THEN
    Y.MV.TAG = "Bcc"
    GOSUB PROCESS.MV
  END
  Y.EMAIL.INFO.XML<-1> = "</Address>"

* ====================================================
* Message
* ====================================================

  Y.EMAIL.INFO.XML<-1> = '<Message type="' : R.EMAIL<E_MAIL.TYPE> : '">'
  Y.EMAIL.INFO.XML<-1> = '<Subject>' : R.EMAIL<E_MAIL.SUBJECT> : '</Subject>';
  Y.EMAIL.INFO.XML<-1> = '<Body>' : R.EMAIL<E_MAIL.BODY> : '</Body>';
* Attachments
  Y.MV.TO.PROCESS = R.EMAIL<E_MAIL.ATTACHMENT>
  Y.MV.TO.PROCESS = CHANGE(Y.MV.TO.PROCESS,"\","/")
  IF Y.MV.TO.PROCESS NE "" THEN
    Y.MV.TAG = "Attachment"
    GOSUB PROCESS.MV
  END
  Y.EMAIL.INFO.XML<-1> = "</Message>"
  Y.EMAIL.INFO.XML<-1> = "</Email>"
  Y.EMAIL.INFO.XML<-1> = "</T24MailPackage>"

  RETURN
*-----------------------------------------------------------------------------
PROCESS.MV:
*-----------------------------------------------------------------------------
  LOOP
    REMOVE Y.MV FROM Y.MV.TO.PROCESS SETTING Y.MV.POS
  WHILE Y.MV : Y.MV.POS
    Y.EMAIL.INFO.XML<-1> = "<" : Y.MV.TAG : ">" : Y.MV : "</" : Y.MV.TAG : ">"
  REPEAT
  RETURN
*-----------------------------------------------------------------------------
END

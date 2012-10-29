<?php
namespace RobertLemke\RobertLemkeCom\ViewHelpers;

/**
 * A workaround-language switcher … for the time being
 *
 * @api
 */
class LanguageSwitchViewHelper extends \TYPO3\Fluid\Core\ViewHelper\AbstractViewHelper {

	/**
	 * Render the language switch
	 *
	 * @return string HTML code
	 * @api
	 */
	public function render($format) {
		$uri = $this->controllerContext->getRequest()->getHttpRequest()->getUri();
		if (substr($uri->getPath(), 0, 4) === '/en/') {
			$en = 'active';
			$de = 'inactive';
		} else {
			$en = 'inactive';
			$de = 'active';
		}

		$enUri = clone $uri;
		$deUri = clone $uri;

		$enUri->setPath('/en/home.html');
		$deUri->setPath('/de/home.html');
		$html = '
			<div class="languageswitch">
				<a href="' . $deUri . '" class="' . $de . '">' . ($format == 'short' ? 'de' : 'deutsch') . '</a>
				<a href="' . $enUri . '" class="' . $en . '">' . ($format == 'short' ? 'en' : 'english') . '</a>
			</div>
		';
		return $html;
	}
}


?>